# code/src/mobile/e2e/steps — Screen-Object Helpers

Screen-object models and reusable step utilities consumed by feature specs in `../features/`.

## Conventions

- One file per screen or logical area: `LoginScreen.ts`, `ProfileScreen.ts`
- Each file exports a plain object or class with methods that encapsulate Detox element queries
- No test assertions inside screen objects — only interactions and element access
- Assertions belong in the feature spec that calls the screen object

## Example shape

```typescript
export const LoginScreen = {
  emailInput: () => element(by.id('login-email')),
  passwordInput: () => element(by.id('login-password')),
  submitButton: () => element(by.id('login-submit')),
  async fillAndSubmit(email: string, password: string) {
    await this.emailInput().typeText(email);
    await this.passwordInput().typeText(password);
    await this.submitButton().tap();
  },
};
```

## Cross-references

- `code/src/mobile/e2e/features/CONTEXT.md` — specs that consume these helpers
