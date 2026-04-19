import '../global.css';
import { Slot } from 'expo-router';
import StorybookUI from '../.storybook';

const STORYBOOK_ENABLED = process.env.EXPO_PUBLIC_STORYBOOK_ENABLED === 'true';

export default function RootLayout() {
  if (__DEV__ && STORYBOOK_ENABLED) {
    return <StorybookUI />;
  }
  return <Slot />;
}
