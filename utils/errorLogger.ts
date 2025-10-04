
// Global error logging for runtime errors

import { Platform } from "react-native";

// Simple debouncing to prevent duplicate errors
const recentErrors: { [key: string]: boolean } = {};
const clearErrorAfterDelay = (errorKey: string) => {
  setTimeout(() => delete recentErrors[errorKey], 100);
};

// Function to send errors to parent window (React frontend)
const sendErrorToParent = (level: string, message: string, data: any) => {
  // Create a simple key to identify duplicate errors
  const errorKey = `${level}:${message}:${JSON.stringify(data)}`;

  // Skip if we've seen this exact error recently
  if (recentErrors[errorKey]) {
    return;
  }

  // Mark this error as seen and schedule cleanup
  recentErrors[errorKey] = true;
  clearErrorAfterDelay(errorKey);

  try {
    if (typeof window !== 'undefined' && window.parent && window.parent !== window) {
      window.parent.postMessage({
        type: 'EXPO_ERROR',
        level: level,
        message: message,
        data: data,
        timestamp: new Date().toISOString(),
        userAgent: typeof navigator !== 'undefined' ? navigator.userAgent : 'unknown',
        source: 'expo-template'
      }, '*');
    } else {
      // Fallback to console if no parent window
      console.log('🚨 ERROR (no parent):', level, message, data);
    }
  } catch (error) {
    console.log('❌ Failed to send error to parent:', error);
  }
};

// Function to extract meaningful source location from stack trace
const extractSourceLocation = (stack: string): string => {
  if (!stack) return '';

  // Look for various patterns in the stack trace
  const patterns = [
    // Pattern for app files: app/filename.tsx:line:column
    /at .+\/(app\/[^:)]+):(\d+):(\d+)/,
    // Pattern for components: components/filename.tsx:line:column
    /at .+\/(components\/[^:)]+):(\d+):(\d+)/,
    // Pattern for any .tsx/.ts files
    /at .+\/([^/]+\.tsx?):(\d+):(\d+)/,
    // Pattern for bundle files with source maps
    /at .+\/([^/]+\.bundle[^:]*):(\d+):(\d+)/,
    // Pattern for any JavaScript file
    /at .+\/([^/\s:)]+\.[jt]sx?):(\d+):(\d+)/
  ];

  for (const pattern of patterns) {
    const match = stack.match(pattern);
    if (match) {
      return ` | Source: ${match[1]}:${match[2]}:${match[3]}`;
    }
  }

  // If no specific pattern matches, try to find any file reference
  const fileMatch = stack.match(/at .+\/([^/\s:)]+\.[jt]sx?):(\d+)/);
  if (fileMatch) {
    return ` | Source: ${fileMatch[1]}:${fileMatch[2]}`;
  }

  return '';
};

// Function to get caller information from stack trace
const getCallerInfo = (): string => {
  const stack = new Error().stack || '';
  const lines = stack.split('\n');

  // Skip the first few lines (Error, getCallerInfo, console override)
  for (let i = 3; i < lines.length; i++) {
    const line = lines[i];
    if (line.indexOf('app/') !== -1 || line.indexOf('components/') !== -1 || line.indexOf('.tsx') !== -1 || line.indexOf('.ts') !== -1) {
      const match = line.match(/at .+\/([^/\s:)]+\.[jt]sx?):(\d+):(\d+)/);
      if (match) {
        return ` | Called from: ${match[1]}:${match[2]}:${match[3]}`;
      }
    }
  }

  return '';
};

export const setupErrorLogging = () => {
  try {
    // Capture unhandled errors in web environment
    if (typeof window !== 'undefined') {
      // Override window.onerror to catch JavaScript errors
      window.onerror = (message, source, lineno, colno, error) => {
        try {
          const sourceFile = source ? source.split('/').pop() : 'unknown';
          const errorData = {
            message: message,
            source: `${sourceFile}:${lineno}:${colno}`,
            line: lineno,
            column: colno,
            error: error?.stack || error,
            timestamp: new Date().toISOString()
          };

          console.log('🚨 RUNTIME ERROR:', errorData);
          sendErrorToParent('error', 'JavaScript Runtime Error', errorData);
        } catch (handlerError) {
          console.log('Error in window.onerror handler:', handlerError);
        }
        return false; // Don't prevent default error handling
      };

      // check if platform is web
      if (Platform.OS === 'web') {
        // Capture unhandled promise rejections with proper error handling
        window.addEventListener('unhandledrejection', (event) => {
          try {
            const errorData = {
              reason: event.reason,
              timestamp: new Date().toISOString(),
              handled: true
            };

            console.log('🚨 UNHANDLED PROMISE REJECTION (handled):', errorData);
            sendErrorToParent('error', 'Unhandled Promise Rejection', errorData);
            
            // Prevent the unhandled rejection from causing app crashes
            event.preventDefault();
          } catch (handlerError) {
            console.log('Error in unhandledrejection handler:', handlerError);
          }
        });

        // Also handle rejectionhandled events
        window.addEventListener('rejectionhandled', (event) => {
          try {
            console.log('🔄 Promise rejection was handled after being unhandled:', event.reason);
          } catch (handlerError) {
            console.log('Error in rejectionhandled handler:', handlerError);
          }
        });
      }
    }

    // Store original console methods
    const originalConsoleError = console.error;
    const originalConsoleWarn = console.warn;
    const originalConsoleLog = console.log;

    // Override console.error with proper error handling
    console.error = (...args: any[]) => {
      try {
        const stack = new Error().stack || '';
        const sourceInfo = extractSourceLocation(stack);
        const callerInfo = getCallerInfo();

        // Create enhanced message with source information
        const enhancedMessage = args.join(' ') + sourceInfo + callerInfo;

        // Add timestamp and make it stand out in Metro logs
        originalConsoleError('🔥 ERROR:', new Date().toISOString(), enhancedMessage);

        // Also send to parent with error handling
        try {
          sendErrorToParent('error', 'Console Error', enhancedMessage);
        } catch (sendError) {
          originalConsoleLog('Failed to send error to parent:', sendError);
        }
      } catch (overrideError) {
        // Fallback to original console.error if our override fails
        originalConsoleError('Error in console.error override:', overrideError);
        originalConsoleError(...args);
      }
    };

    console.log('✅ Error logging setup completed successfully');

  } catch (setupError) {
    console.log('❌ Failed to setup error logging:', setupError);
  }
};
