/**
 * A reference custom authentication strategy created for authentication using firebase.
 */
 let firebaseConfig = {
    apiKey: "YOUR API KEY HERE",
    authDomain: "YOUR AUTH DOMAIN HERE",
    databaseURL: "YOUR DB URL HERE",
    projectId: "PROJECT ID",
    storageBucket: "STORAGE BUCKET",
    messagingSenderId: "SENDER ID",
    appId: "APP ID",
    measurementId: "MEASUREMENT ID"
  };
  let firebaseApp = null;
  /**
   * Method to initialise the firebase sdk.
   */
  export function initAuthConfig(input){
    if(input){
      firebaseConfig = input;
      if (!firebase.apps.length) {
          firebaseApp = firebase.initializeApp(input);
      }
    }
  }
  /**
   * Method to allow existing users to sign in using their email address and password
   */
  export function signIn(input) {
    return firebaseApp
      .auth()
      .signInWithEmailAndPassword(input.email, input.password)
      .then(response => {
        return response;
      })
      .then(async user => {
        return await postSignIn(user.user);
      })
      .catch(error => {
        throw error;
      });
  }
  
  /**
   * Method to allow post signIn operations. Getting JWT token for loggedIn user
   */
  export async function postSignIn(user) {
    let signInResponse = {};
    signInResponse.userDetail = user;
    return await user
      .getIdToken()
      .then(idToken => {
        signInResponse.sessionToken = idToken;
        return signInResponse;
      })
      .catch(error => {
        throw error;
      });
  }
  
  /**
   * Method to register a new user to firebase app using email address and a password
   */
  export function signUp(input) {
    return firebaseApp
      .auth()
      .createUserWithEmailAndPassword(input.email, input.password)
      .then(async response => {
        if (response) {
          const userProfile = response && response.user;
          if (userProfile != null) {
            const userName = input.firstName + " " + input.lastName;
            return await userProfile
              .updateProfile({
                displayName: userName
              })
              .then(async () => {
                return await postSignUp(userProfile);
              })
              .catch(error => {
                return error;
              });
          }
        }
        return response;
      })
      .catch(error => {
        throw error;
      });
  }
  
  /**
   * Method to allow post signUp operations. Getting JWT token for new user
   */
  export async function postSignUp(user) {
    let signUpResponse = {};
    signUpResponse.userDetail = user;
    return await user
      .getIdToken()
      .then(idToken => {
        signUpResponse.sessionToken = idToken;
        return signUpResponse;
      })
      .catch(error => {
        throw error;
      });
  }
  
  /**
   * Method to allow signOut operations
   */
  export async function signOut() {
    return firebaseApp
      .auth()
      .signOut()
      .then(() => {
        return true;
      })
      .then(async response => {
        return await postSignOut(response);
      })
      .catch(error => {
        throw error;
      });
  }
  
  /**
   * Method to allow post signOut operations
   */
  export async function postSignOut(input) {
    return input;
  }