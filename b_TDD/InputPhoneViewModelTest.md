
## InputPhoneViewModel class

```kotlin
class InputPhoneViewModel(  
    val agreementsAdapterFactory: AgreementsAdapterFactory,  
    private val coroutineDispatchers: CoroutineDispatchers,  
    private val agreementsInteractor: AgreementsInteractor,  
    private val router: IInputPhoneRouter,  
    private val openLegalDocumentUseCase: OpenLegalDocumentUseCase,  
    private val requestVerificationCodeUseCase: RequestVerificationCodeUseCase,  
    private val formValidator: PhoneValidator,  
    private val analyticsManager: AnalyticsManager,  
) : ViewModel() {  
  
    private val _isLoading = MutableStateFlow(false)  
    val isLoading = _isLoading.asStateFlow()  
  
    private val _error = MutableSharedFlow<Error>()  
    val error = _error.asSharedFlow()  
  
    private val _agreementError = MutableSharedFlow<Unit>()  
    val agreementError = _agreementError.asSharedFlow()  
  
    private val isPhoneValid = MutableStateFlow(false)  
    private val isAllRequiredAgreementsChecked = MutableStateFlow(false)  
  
    val isButtonEnabled: Flow<Boolean> = combine(  
        isPhoneValid,  
        isAllRequiredAgreementsChecked  
    ) { isPhoneValid, isAllRequiredAgreementsChecked ->  
        isPhoneValid && isAllRequiredAgreementsChecked  
    }.distinctUntilChanged()  
  
    private val _agreementsModel = MutableStateFlow(AgreementsSmsModel(listOf()))  
    val agreementsModel = _agreementsModel.asStateFlow()  
        .onEach { model ->  
            val isAllRequiredBlocksChecked = model.items.none { it.isRequired && !it.isSelected }  
            isAllRequiredAgreementsChecked.value = isAllRequiredBlocksChecked  
        }.distinctUntilChanged()  
  
    private val errorMapper = PhoneErrorMapper()  
  
    private val inputEventSent = AtomicBoolean(false)  
    private var phone: String = ""  
  
    init {  
        agreementsInteractor.getAgreementsSmsModel()  
            .flowOn(coroutineDispatchers.io)  
            .onStart { _isLoading.value = true }  
            .catch {  
                Timber.e(it)  
                _error.emit(errorMapper.map(it))  
            }  
            .onEach { _agreementsModel.emit(it) }  
            .onCompletion { _isLoading.value = false }  
            .launchIn(viewModelScope)  
    }  
  
    fun onPhoneUpdate(phone: String) {  
        if (phone.length > 2 && inputEventSent.compareAndSet(false, true)) {  
            analyticsManager.sendEvent(FirstDigitEntered)  
        }  
        this.phone = phone  
        formValidator.validate(phone).toObservable().asFlow().take(1)  
            .onEach { isPhoneValid.value = it.isPhoneValid }  
            .launchIn(viewModelScope)  
    }  
  
    fun onContinueClicked() {  
        analyticsManager.sendEvent(ContinueClicked)  
        requestSignUpCode(phone)  
    }  
  
    private fun requestSignUpCode(phone: String) =  
        requestVerificationCodeUseCase(RequestVerificationCodeParams(phone))  
            .onStart { _isLoading.value = true }  
            .catch { _error.emit(errorMapper.map(it)) }  
            .onEach { router.navigateToVerificationCode(phone) }  
            .onCompletion { _isLoading.value = false }  
            .launchIn(viewModelScope)  
  
    fun onSingInClicked() = router.navigateToSingIn()  
  
    fun navigateToSignIn() = router.navigateToSingIn(phone)  
  
    fun onAgreementsBlockCheckboxClicked(agreementItemModel: CheckBoxModel) {  
        _agreementsModel.value.let {  
            val newBlocks = it.items.map { item ->  
                if (item.id == agreementItemModel.id) {  
                    agreementItemModel  
                } else {  
                    item  
                }  
            }  
            _agreementsModel.value = it.copy(items = newBlocks)  
        }  
    }  
  
    fun onDocumentClicked(document: LegalDocument) {  
        openLegalDocumentUseCase.openLegalDocument(document)  
            .onStart { _isLoading.value = true }  
            .catch {  
                Timber.e(it)  
                _agreementError.emit(Unit)  
            }  
            .onCompletion { _isLoading.value = false }  
            .launchIn(viewModelScope)  
    }  
  
    data class Error(  
        @StringRes val screenError: Int? = null,  
        @StringRes val identityError: Int? = null,  
        val errorMessage: String? = null  
    )  
}
```

## Test class
```kotlin
/**  
 * Test for [InputPhoneViewModel]  
 *  
 * @author Denys Kalashnyk on 20.11.23  
 */
 class InputPhoneViewModelTest : CoreViewModelTest() {  
  
    private val agreementsInteractor = mockk<AgreementsInteractor> {  
        val expectedModel = AgreementsSmsModel(  
            items = listOf(  
                CheckBoxModel(  
                    id = "1",  
                    linkedTextModel = LinkedTextModel(),  
                    isRequired = false,  
                    isSelected = true,  
                )  
            ),  
        )  
        every { getAgreementsSmsModel() } returns flowOf(expectedModel)  
    }  
    private val agreementsAdapterFactory = mockk<AgreementsAdapterFactory>()  
    private val router = mockk<IInputPhoneRouter>(relaxed = true)  
    private val openLegalDocumentUseCase = mockk<OpenLegalDocumentUseCase>()  
    private val requestVerificationCodeUseCase = mockk<RequestVerificationCodeUseCase>()  
    private val formValidator = mockk<PhoneValidator>()  
    private val analyticsManager = mockk<AnalyticsManager>(relaxed = true)  
  
    private val viewModel = getViewModel()  
  
    @OptIn(ExperimentalCoroutinesApi::class)  
    private fun getViewModel(): InputPhoneViewModel {  
		
		// ЭТА СТРОКА решает ошибку "Exception in thread "Test worker" ..."
        Dispatchers.setMain(StandardTestDispatcher())  
	    
		val viewModel = InputPhoneViewModel(  
            coroutineDispatchers = TestCoroutineDispatchers,  
            agreementsInteractor = agreementsInteractor,  
            agreementsAdapterFactory = agreementsAdapterFactory,  
            router = router,  
            openLegalDocumentUseCase = openLegalDocumentUseCase,  
            requestVerificationCodeUseCase = requestVerificationCodeUseCase,  
            formValidator = formValidator,  
            analyticsManager = analyticsManager,  
        )  
        // ЭТА ПРОВЕРКА для init {}
        verify { agreementsInteractor.getAgreementsSmsModel() }  
        
        return viewModel  
    }  
  
    @Test  
    fun `on SingIn clicked`() {  
        // Do  
        viewModel.onSingInClicked()  
  
        // Check  
        verify { router.navigateToSingIn() }  
    }  
  
    @Test  
    fun `on Continue clicked`() {  
        // Set  
        every { requestVerificationCodeUseCase.invoke(RequestVerificationCodeParams("", "", false)) } returns flowOf(Unit)  
  
        // Do  
        viewModel.onContinueClicked()  
  
        // Check  
        verify { router.navigateToVerificationCode("") }  
    }  
  
    @Test  
    fun `on Document clicked`() {  
        // Set  
        val document = LegalDocument("", "", "")  
        every { openLegalDocumentUseCase.openLegalDocument(document) } returns flowOf("")  
  
        // Do  
        viewModel.onDocumentClicked(document)  
  
        // Check  
        verify { openLegalDocumentUseCase.openLegalDocument(document) }  
    }  
}
```