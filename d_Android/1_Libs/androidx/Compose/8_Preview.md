

```kotlin
@Preview
@Composable
fun UserCard(
	@PreviewParameter (UserPreviewProvider::class) user: User,
	modifier: Modifier = Modifier,
	...
){...}
```

```kotlin
private class UserPreviewProvider : PreviewParameterProvider<User>{

	override val values: Sequence<User> = sequenceOf(
		User(
			id = 1,
			name = "Gandalf",
			status = "Lorem ipsum",
		),
		User(
			id = 1,
			name = "Gandalf the White, the leader og the Fellowship of the Ring",
			status = "bla bla very long text",
		),
	)
}
```