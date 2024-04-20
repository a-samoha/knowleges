```kotlin
DatePickerDialog(  
    requireContext(), 
    R.style.auth_SpinnerDatePickerDialogTheme, // меняет внешний вид пикера на спинер
    { _, year, month, day ->  
        set(year, month, day)  
        set(Calendar.HOUR_OF_DAY, 0)  
        set(Calendar.MINUTE, 0)  
        set(Calendar.SECOND, 0)  
        set(Calendar.MILLISECOND, 0)  
        binding.dateOfBirthInputText.setText(  
            BaseInputPersonalInfoViewModel.dateFormat.format(time)  
        )  
    },
```


# MaterialDatePicker (set period)

``` kotlin
private fun getPeriodFromDatePicker() {  
	val from: ZonedDateTime? = to?.withDayOfMonth(1) // предвыбранная дата
	val to: ZonedDateTime? = ZonedDateTime.now() // предвыбранная дата
	  
    MaterialDatePicker.Builder.dateRangePicker()  
        .setTitleText("Choose Some Period")
        .apply {  // установка предвыбранных дат
            if (from != null && to != null) {  
                setSelection(  
                    androidx.core.util.Pair(  
                        GregorianCalendar.from(from).timeInMillis + TimeZone.getDefault().rawOffset,  
                        GregorianCalendar.from(to).timeInMillis + TimeZone.getDefault().rawOffset  
                    )  
                )  
            }  
        }  
        .setCalendarConstraints(  
            CalendarConstraints.Builder()  
                .setValidator(DateValidatorPointBackward.now())  
                .build()  
        )  
        .build()  
        .apply {  
                addOnPositiveButtonClickListener {  
                    val calendar = GregorianCalendar()  
                    calendar.timeInMillis = it.first + abs(TimeZone.getDefault().rawOffset)  
                    val selectionStart = calendar.toZonedDateTime()  
                    calendar.timeInMillis = it.second + abs(TimeZone.getDefault().rawOffset)  
                    val selectionEnd = calendar.toZonedDateTime()  
					
                    val period = FilterParam.Period(  
                        isSelected = true,  
                        range = CUSTOM,  
                        from = selectionStart.withTimeAtStartOfDayUtc(),  
                        to = selectionEnd.withTimeAtEndOfDayUtc()  
                    )  
                    onPeriodSelected(period)  // кастомный метод, в котором я использую выбранные значения
                }
                addOnDismissListener {  
				    println("Date Picker dialog dismissed") 
				}
        }.show(childFragmentManager, "TAG")  
}
```


