# code/src/mobile/src/components — Reusable React Native Components

Mobile-specific UI components. These are primitives and composites used across multiple screens.

## Conventions

- One component per file — filename matches the exported component name: `Button.tsx`, `Avatar.tsx`
- Every component must have a co-located test: `Button.test.tsx`
- Every component must have a co-located story: `Button.stories.tsx`
- No screen-specific logic — components here must be reusable across at least two screens
- Use NativeWind `className` prop for styling — no `StyleSheet.create` in new components
- Prefer `@syntek/shared` components before writing a mobile-specific one

## Story shape

```typescript
import type { Meta, StoryObj } from '@storybook/react-native';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'Mobile/Button',
  component: Button,
};
export default meta;

type Story = StoryObj<typeof Button>;
export const Primary: Story = { args: { label: 'Press me' } };
```

## Cross-references

- `code/src/shared/src/components/CONTEXT.md` — shared components available to mobile
- `code/src/mobile/.storybook/CONTEXT.md` — how stories are discovered and run on-device
