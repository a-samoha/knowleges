
```kotlin
abstract class BaseFragment<V : ViewBinding> : Fragment() {  
  
    private var _binding: V? = null  
  
    val binding get(): V = _binding!!  
  
    val nullableBinding get(): V? = _binding  
  
    abstract val inflater: (LayoutInflater, ViewGroup?, Boolean) -> V  
  
    override fun onCreateView(  
        inflater: LayoutInflater,  
        container: ViewGroup?,  
        savedInstanceState: Bundle?  
    ): View? {  
        _binding = this.inflater.invoke(inflater, container, false)  
        return binding.root  
    }  
  
    override fun onDestroyView() {  
        super.onDestroyView()  
        _binding = null  
    }  
}
```

```kotlin
class LoginScreen : BaseFragment<AuthFragmentLoginBinding>(){  

	private val viewModel by viewModel<BaseLoginViewModel>()
	
	override val inflater: (LayoutInflater, ViewGroup?, Boolean) -> AuthFragmentLoginBinding  
	    get() = AuthFragmentLoginBinding::inflate
	
	override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
	    super.onViewCreated(view, savedInstanceState)  
	    viewModel.setup()
	}
	
	private fun BaseLoginViewModel.setup() = with(binding) {  
	    attach(object : BaseLoginViewModel.Input {  
	        override val onPhoneChanged = configurePhoneInputObservable().distinctUntilChanged()  
	        override val onPasswordChanged = configurePasswordInputObservable().distinctUntilChanged()  
	        override val onForgotPasswordClicked = forgotPasswordText.throttleClicks()  
	        override val onLoginClicked = loginButton.throttleClicks()  
	        override val onSignUpClicked = buttonSignUp.throttleClicks() 
	    }).subscribe(viewLifecycleOwner)  
		  
	    error  
	        .observeOn(AndroidSchedulers.mainThread())  
	        .doOnNext {  
	            it.screenError?.let { message -> showToast(message) }  
	        }        .subscribe(viewLifecycleOwner)  
		  
	    isLoading  
	        .observeOn(AndroidSchedulers.mainThread())  
	        .doOnNext { isVisible ->  
	            rootView.setLoadingState(isVisible, loginButton)  
	            progressBar.isVisible = isVisible  
	        }  
	        .subscribe(viewLifecycleOwner)  
		  
	}
}
```

```kotlin
abstract class BaseLoginViewModel : RxViewModel() {  
	
	abstract val error: Observable<Error>  
	abstract val isLoading: Observable<Boolean>
	  
	abstract fun attach(input: Input): Observable<*>
	
    interface Input {  
        val onPhoneChanged: Observable<String>  
        val onPasswordChanged: Observable<String>  
        val onForgotPasswordClicked: Observable<Unit>  
        val onLoginClicked: Observable<Unit>  
        val onSignUpClicked: Observable<Unit>  
    }  
}
```

```kotlin
class LoginViewModel(  
    private val router: ILoginRouter,  
) : BaseLoginViewModel() {

	override val error: PublishSubject<Error> = PublishSubject.create()  
	override val isLoading: BehaviorSubject<Boolean> = BehaviorSubject.createDefault(false)

	override fun attach(input: Input): Observable<*> {  
	    with(input) {  
	        return Observable.mergeArray(  
	            onLoginClicked  
	                .switchMapCompletable { performLogin(input) }  
	                .retry()  
	                .toObservable(),  
				  
	            onForgotPasswordClicked.flatMapCompletable {  
	                getLatest(input)  
	                    .switchMapCompletable {  
	                        if (it.first.length >= 12) {  
	                            performPasswordRecovery(input)  
	                        } else {  
	                            router.navigateToForgotPassword()  
	                            Completable.complete()  
	                        }  
	                    }  
	            }.retry()  
	                .toObservable(),  
				  
	            onSignUpClicked.doOnNext { router.navigateToSignUp() },  
				  
	            getLatest(input)  
	                .flatMapSingle {  
	                    loginFormValidator.validate(LoginFormValidator.Input(phone = it.first, password = it.second))  
	                }.map {  
	                    isLoginEnabled.onNext(it.isAllFieldsValid)  
	                })  
	    }  
	}
	
	private fun performLogin(input: Input): Completable = with(input) {  
	    return getLatest(this)  
	        .flatMapCompletable { login(it.first, it.second) }  
	        .applySchedulers()  
	        .doOnError { errorMapper.map(it).let(error::onNext) }  
	}
	
	private fun getLatest(input: Input) = with(input) {  
	    Observable.combineLatest(onPhoneChanged, onPasswordChanged) { phone, password ->  
	        Pair(phone, password)  
	    }  
	}
}
```