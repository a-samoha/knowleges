```kotlin
class TooltipDialogScreen() : BottomSheetDialogFragment() {  
	  
	private val binding by viewBinding(TooltipDialogBinding::bind)  
	private val viewModel by viewModel<TooltipDialogViewModel> { parametersOf(arguments, requireActivity()) }  
	  
	override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? =  
		inflater.inflate(R.layout.tooltip_dialog, container, false)  
	
	// default height of the dialog
	override fun onCreateDialog(savedInstanceState: Bundle?): Dialog =  
	    BottomSheetDialog(requireContext()).apply {  
		    setOnShowListener { dialogInterface ->  
		        (dialogInterface as BottomSheetDialog).findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)  
		            ?.let { view -> BottomSheetBehavior.from(view).state = BottomSheetBehavior.STATE_EXPANDED }  
		    }
	    }
	
	/*    OR    */ ------------------------------------------------------------------------------------------------------------
	
	// setupWrapContentHeight of the dialog
	override fun onCreateDialog(savedInstanceState: Bundle?): Dialog =  
	    BottomSheetDialog(requireContext(), R.style.B9BottomSheetDialog).apply {  
	        setOnShowListener {  
				// ЕСЛИ ботомщит диалог не открывается полность 
				// (часть содержания ушло под системный navigation bar)
				// нужно использовать кастомный метод setupWrapContentHeight
				BottomSheetDialogUtil.setupWrapContentHeight(requireActivity(), this)
	        }  
	    }
	
	/*    OR    */ ------------------------------------------------------------------------------------------------------------
	
	// will render the "topOffset" setted height of the dialog
	override fun onCreateDialog(savedInstanceState: Bundle?): Dialog =  
	    BottomSheetDialog(requireContext(), R.style.B9BottomSheetDialog).apply {  
	        setOnShowListener {  
				// используя topOffset - хардкордно регулируем высоту затемненного пространства
	            val topOffset = resources.getDimensionPixelSize(R.dimen.bottom_sheet_top_offset) // 16dp
	            setupFullHeight(requireActivity(), this, topOffset)  
	        }  
	    }
		  
	override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {  
	    binding = TtDialogScreenBinding.inflate(inflater, container, false)  
	    return binding?.root  
	}
	
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {  
        super.onViewCreated(view, savedInstanceState)  
		  
        viewModel.termsDetailsUiState  
            .onEach(::renderUi)  
            .launchIn(lifecycleScope)  
		
        setListeners()  
    }
	
	// ПЕРЕХВАТЫВАМ клик по серой области вокруг BottomSheetDialog
	override fun onStart() {  
	    super.onStart()  
	    stopOutsideClick()  
	}  
	  
	private fun stopOutsideClick() {  
	    touchOutsideView = dialog?.window?.decorView?.findViewById(com.google.android.material.R.id.touch_outside)  
	    touchOutsideView?.setOnClickListener { onCloseClick() }  
	}  
	  
	private fun onCloseClick(){  
	    viewModel.onCloseClick()  
	    dismiss()  
	}  
	  
	override fun onDestroyView() {  
	    binding = null  
	    touchOutsideView?.setOnClickListener(null) // ВАЖНО удалить ClickListener иначе утечка памяти
	    super.onDestroyView()  
	}
    ...
```

##### Set Height

``` kotlin	
object BottomSheetDialogUtil {  
  
    fun setupFullHeight(activity: Activity, dialog: BottomSheetDialog, topOffset: Int) {  
        dialog.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)?.let { view ->  
            view.updateLayoutParams {  
                val insets = dialog.window?.decorView?.rootWindowInsets?.let { WindowInsetsCompat.toWindowInsetsCompat(it) }  
                val systemBarInsets = insets?.getInsets(WindowInsetsCompat.Type.systemBars())  
                val statusBarHeight = systemBarInsets?.top ?: 0  
                val navBarHeight = systemBarInsets?.bottom ?: 0  
                height = getWindowHeight(activity) - topOffset - statusBarHeight - navBarHeight  
            }  
            val behavior = BottomSheetBehavior.from(view)  
            behavior.state = BottomSheetBehavior.STATE_EXPANDED  
        }  
    }  
  
    fun setupWrapContentHeight(activity: Activity, dialog: BottomSheetDialog) {  
        dialog.findViewById<View>(com.google.android.material.R.id.design_bottom_sheet)?.let { view ->  
            view.updateLayoutParams {  
                val obscuredHeight = getWindowHeight(activity) - height  
                val insets = dialog.window?.decorView?.rootWindowInsets?.let { WindowInsetsCompat.toWindowInsetsCompat(it) }  
                val systemBarInsets = insets?.getInsets(WindowInsetsCompat.Type.systemBars())  
                val statusBarHeight = systemBarInsets?.top ?: 0  
                val navBarHeight = systemBarInsets?.bottom ?: 0  
                height = getWindowHeight(activity) - statusBarHeight - navBarHeight - obscuredHeight  
            }  
            val behavior = BottomSheetBehavior.from(view)  
            behavior.state = BottomSheetBehavior.STATE_EXPANDED  
        }  
    }  
  
    @Suppress("DEPRECATION")  
    private fun getWindowHeight(activity: Activity): Int {  
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {  
            activity.windowManager.currentWindowMetrics.bounds.height()  
        } else {  
            DisplayMetrics().also {  
                activity.windowManager.defaultDisplay.getMetrics(it)  
            }.heightPixels  
        }  
    }  
}
```

##### Prevent from dismissing when the user touches outside of the bottomsheet

```kotlin
  override fun onStart() {  
    super.onStart()  
    stopOutsideClick()  
}  
  
private fun stopOutsideClick() {  
    val touchOutsideView = dialog?.window?.decorView?.findViewById<View>(com.google.android.material.R.id.touch_outside)  
    touchOutsideView?.setOnClickListener { onCloseClick() }  
}  
  
private fun onCloseClick(){  
    viewModel.onCloseClick()  
    dismiss()  
}
```

