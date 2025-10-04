
import React, { useEffect, useState } from 'react';
import { SafeAreaProvider, useSafeAreaInsets, SafeAreaView } from 'react-native-safe-area-context';
import { Stack, useGlobalSearchParams } from 'expo-router';
import { Platform } from 'react-native';
import { setupErrorLogging } from '../utils/errorLogger';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

const STORAGE_KEY = 'natively_emulate_device';

export default function RootLayout() {
  const insets = useSafeAreaInsets();
  const [emulate, setEmulate] = useState(false);
  const params = useGlobalSearchParams();

  useEffect(() => {
    try {
      // Setup error logging with proper error handling
      console.log('Setting up error logging...');
      setupErrorLogging();
      console.log('Error logging setup completed');
    } catch (error) {
      console.log('Failed to setup error logging:', error);
    }
  }, []);

  useEffect(() => {
    try {
      // Handle emulation parameter
      if (params.emulate === 'true') {
        setEmulate(true);
        console.log('Device emulation enabled');
      } else if (params.emulate === 'false') {
        setEmulate(false);
        console.log('Device emulation disabled');
      }
    } catch (error) {
      console.error('Error handling emulation parameter:', error);
    }
  }, [params.emulate]);

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <SafeAreaView style={{ flex: 1 }}>
          <Stack
            screenOptions={{
              headerShown: false,
              contentStyle: { backgroundColor: 'transparent' },
            }}
          />
        </SafeAreaView>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}
