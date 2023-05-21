import 'core-js/actual';
import 'url-polyfill';

import { TextEncoder, TextDecoder } from 'text-encoding-polyfill';
self.TextEncoder = TextEncoder;
self.TextDecoder = TextDecoder;
