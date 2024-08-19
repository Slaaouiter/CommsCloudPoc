/**
 * This module exposes all the methods of your authentication strategy. 
 * For reference implementation a util file called dcFirebaseSDKStrategy is created and it's methods are exposed using this module.
 * Any custom auth strategy could be created and exposed using this authnetication util module.
 */
 import {initAuthConfig,signIn,signUp,signOut} from "./vnosDcFirebaseSdkStrategy";

 export {initAuthConfig,signIn,signUp,signOut};
 
 let authConfiguration = null;
 
 export function setAuthConfiguration(configuration) {
     if (configuration) {
         authConfiguration = configuration;
     } else {
         return authConfiguration;
     }
 }