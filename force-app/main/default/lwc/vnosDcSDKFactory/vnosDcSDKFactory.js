//import fetchUserContext from "@salesforce/apex/FetchUserDetails.fetchUserContext";
import { fetchUserContext } from "vlocity_cmt/salesforceUtils";
import { loadScript } from "lightning/platformResourceLoader";
import { load as loadNewport } from "vlocity_cmt/newportLoader";
//import isCommunity from "@salesforce/apex/vlocit_cmt.LWCDatasource.isCommunity";

let singletonSDKMap = {};
let singletonSDKTranslationMap = {};
let singletonAccountMap = {};
let retryCounter = 3;
let defaultNamespace = "c";
let currentCounter = retryCounter;
let apiUrl = "";
let authToken = "";
let customSalesforceUrl = null;
let checkoutNodeServerUrl = "";
let secureServerRequestCredentials;
let isCommunityPage = false;
let digitalCommerceProxyConfig;
let enableProxySdk = false;

export function setApiUrl(url) {
  if (url) {
    apiUrl = url;
  }
}

export function setAuthToken(token) {
  if (token) {
    authToken = token;
  }
}

export function setCustomSalesforceUrl(url) {
  if (url) {
    customSalesforceUrl = url;
  }
}

export function setCheckoutNodeServerUrl(url) {
  if (url) {
    checkoutNodeServerUrl = url;
  }
}
export function setSecureServerRequestCredentials(requestCredential) {
  if (requestCredential) {
    secureServerRequestCredentials = requestCredential;
  }
}
export function setEnableProxySdk(enableProxySdkFlag) {
  enableProxySdk = enableProxySdkFlag;
}

export function getSDKInstance(namespace, n) {
  if (!namespace) namespace = defaultNamespace;
  if (singletonSDKMap[namespace]) {
    return singletonSDKMap[namespace];
  } else {
    return new Promise((resolve, reject) => {
      fetchUserDetailAsync(namespace)
        .then(sdkInstance => {
          currentCounter = retryCounter;
          resolve(sdkInstance);
        })
        .catch(e => {
          return reject(e);
        });
    });
  }
}

export function getTranslationSDKInstance(namespace) {
  if (!namespace) namespace = defaultNamespace;
  if (singletonSDKTranslationMap[namespace]) {
    return singletonSDKTranslationMap[namespace];
  } else {
    return new Promise((resolve, reject) => {
      fetchUserDetailAsyncTranslation(namespace)
        .then(sdkTranslationInstance => {
          currentCounter = retryCounter;
          resolve(sdkTranslationInstance);
        })
        .catch(e => {
          reject(e);
          return;
        });
    });
  }
}
export function getAccountSDKInstance(namespace) {
  if (!namespace) namespace = defaultNamespace;
  if (singletonAccountMap[namespace]) {
    return singletonAccountMap[namespace];
  } else {
    return new Promise((resolve, reject) => {
      fetchAccountSDKAsync(namespace)
        .then(sdkInstance => {
          currentCounter = retryCounter;
          resolve(sdkInstance);
        })
        .catch(e => {
          return reject(e);
        });
    });
  }
}

export function isDCSDKInstanceAvailable(namespace) {
  //console.log('@@SARB vnosDcSDKFactory isDCSDKInstanceAvailable...', namespace);
  if (!namespace) namespace = defaultNamespace;
  //console.log('@@SARB vnosDcSDKFactory isDCSDKInstanceAvailable defaultNamespace: ', defaultNamespace);
  return singletonSDKMap[namespace] ? true : false;
}
export function isTranslationSDKInstanceAvailable(namespace) {
  if (!namespace) namespace = defaultNamespace;
  return singletonSDKTranslationMap[namespace] ? true : false;
}
export function isAccountSDKInstanceAvailable(namespace) {
  if (!namespace) namespace = defaultNamespace;
  return singletonAccountMap[namespace] ? true : false;
}

export function loadResources(n) {

  getSDKPath("dcSDK").then((sdkPath) => {
    loadScript(
      n,
      "/resource/vlocity_cmt__vlocitydcsdk" + sdkPath
    );
    loadScript(
      n,
      "/resource/vlocity_cmt__dc_firebase" + "/firebase-app.js"
    );
    loadScript(
      n,
      "/resource/vlocity_cmt__dc_firebase" + "/firebase-auth.js"
    );
    loadNewport(n);
  });

  getSDKPath("translationSDK").then((sdkPath) => {
    loadScript(
      n,
      "/resource/vlocity_cmt__vlocitysdk" + sdkPath
    );
  });

  getSDKPath("accountSDK").then((sdkPath) => {
    loadScript(
      n,
      "/resource/vlocity_cmt__vlocityaccountsdk" + sdkPath
    );
  });

}


function fetchUserDetailAsync(namespace) {
  return new Promise((resolve, reject) => {
    if (isCommunityPage && enableProxySdk) {
      digitalCommerceProxyConfig = window.VlocitySDK[
        "digitalcommerce/proxy"
      ].createConfig({
        secureServerUrl: checkoutNodeServerUrl,
        secureServerRequestCredentials: secureServerRequestCredentials
      });
      singletonSDKMap[
        namespace
      ] = window.VlocitySDK[
        "digitalcommerce/proxy"
      ].getInstance(digitalCommerceProxyConfig);
      resolve(singletonSDKMap[namespace]);
    } else {
      fetchUserDetails()
        .then(response => {
          let digitalCommerceConfig = null;
          if (response && response.sessionId !== "") {
            // login user
            if (!apiUrl) {
              response.salesforceURL = customSalesforceUrl || response.salesforceURL;
              digitalCommerceConfig = window.VlocitySDK.digitalcommerce.createConfigForLoginUser(
                response.salesforceURL,
                response.sessionId
              );
            } else {
              //anonymous url
              digitalCommerceConfig = window.VlocitySDK.digitalcommerce.createConfigForAnonymousUser();
            }
            singletonSDKMap[
              namespace
            ] = window.VlocitySDK.digitalcommerce.getInstance(
              digitalCommerceConfig
            );
            let re = /__$/;
            response.namespacePrefix = response.namespacePrefix.replace(re, "");
            singletonSDKMap[namespace].apiURL = apiUrl || "";
            if (authToken) {
              singletonSDKMap[namespace].authToken = authToken;
            }
            singletonSDKMap[namespace].namespace = response.namespacePrefix;
            if (checkoutNodeServerUrl !== "") {
              singletonSDKMap[namespace].secureServerUrl = checkoutNodeServerUrl;
              if (secureServerRequestCredentials) {
                singletonSDKMap[namespace].secureServerRequestCredentials = secureServerRequestCredentials;
              }
            }
          }
          else if (window.VlocitySDK) {
            digitalCommerceConfig = window.VlocitySDK.digitalcommerce.createConfigForAnonymousUser();
            singletonSDKMap[
              namespace
            ] = window.VlocitySDK.digitalcommerce.getInstance(
              digitalCommerceConfig
            );
            if (checkoutNodeServerUrl !== "") {
              singletonSDKMap[namespace].secureServerUrl = checkoutNodeServerUrl;
              if (secureServerRequestCredentials) {
                singletonSDKMap[namespace].secureServerRequestCredentials = secureServerRequestCredentials;
              }
            }
          }
          resolve(singletonSDKMap[namespace]);
        })
        .catch(e => {
          if (currentCounter === 0) {
            currentCounter = retryCounter;
            return reject(e);
          }
          currentCounter--;
          fetchUserDetailAsync()
            .then(resolve)
            .catch(reject);
        });
    }
  });
}

function fetchUserDetailAsyncTranslation(namespace) {
  return new Promise((resolve, reject) => {
    if (isCommunityPage && enableProxySdk) {
      singletonSDKTranslationMap[
        namespace
      ] = VlocitySDK["translation/proxy"].getInstance({
        datasource: digitalCommerceProxyConfig.datasource,
        secureServerUrl: checkoutNodeServerUrl
      });
      resolve(singletonSDKTranslationMap[namespace]);
    } else {
      fetchUserDetails()
        .then(response => {
          let digitalCommerceTranslationConfig = null;
          let digitalCommerceConfig = null;
          if (response && response.sessionId !== "") {
            // login user
            if (!apiUrl) {
              response.salesforceURL = customSalesforceUrl || response.salesforceURL;
              digitalCommerceConfig = window.VlocitySDK.digitalcommerce.createConfigForLoginUser(
                response.salesforceURL,
                response.sessionId
              );
              digitalCommerceTranslationConfig = window.VlocitySDK.translation.getInstance({
                datasource: digitalCommerceConfig.datasource
              });
            } else {
              //anonymous url
              digitalCommerceConfig = window.VlocitySDK.digitalcommerce.createConfigForAnonymousUser();
              digitalCommerceTranslationConfig = window.VlocitySDK.translation.getInstance({
                datasource: digitalCommerceConfig.datasource,
                anonymousUserUrl: apiUrl
              });
            }
            singletonSDKTranslationMap[
              namespace
            ] = digitalCommerceTranslationConfig;
            let re = /__$/;
            response.namespacePrefix = response.namespacePrefix.replace(re, "");
            singletonSDKTranslationMap[namespace].apiURL = apiUrl || "";
            singletonSDKTranslationMap[namespace].language = response.language;
            singletonSDKTranslationMap[namespace].namespace = response.namespacePrefix;
          }
          else if (window.VlocitySDK) {
            digitalCommerceConfig = window.VlocitySDK.digitalcommerce.createConfigForAnonymousUser();
            digitalCommerceTranslationConfig = window.VlocitySDK.translation.getInstance({
              datasource: digitalCommerceConfig.datasource,
              anonymousUserUrl: ""
            });
          }
          resolve(singletonSDKTranslationMap[namespace]);
        })
        .catch(e => {
          if (currentCounter === 0) {
            currentCounter = retryCounter;
            reject(e);
            return;
          }
          currentCounter--;
          fetchUserDetailAsyncTranslation()
            .then(resolve)
            .catch(reject);
        });
    }
  });
}

function fetchAccountSDKAsync(namespace) {
  return new Promise((resolve, reject) => {
    if (isCommunityPage && enableProxySdk) {
      singletonAccountMap[
        namespace
      ] = VlocitySDK["account/proxy"].getInstance({
        datasource: digitalCommerceProxyConfig.datasource,
        secureServerUrl: checkoutNodeServerUrl,
        secureServerRequestCredentials: secureServerRequestCredentials
      });
      resolve(singletonAccountMap[namespace]);
    } else {
      fetchUserDetails()
        .then(response => {
          let accountConfig = null;
          if (response && response.sessionId !== "") {
            // login user
            if (!apiUrl) {
              response.salesforceURL = customSalesforceUrl || response.salesforceURL;
              accountConfig = window.VlocitySDK.account.createConfigForLoginUser(
                response.salesforceURL,
                response.sessionId
              );
            }
            singletonAccountMap[
              namespace
            ] = window.VlocitySDK.account.getInstance(
              accountConfig
            );
            let re = /__$/;
            response.namespacePrefix = response.namespacePrefix.replace(re, "");
            singletonAccountMap[namespace].apiURL = apiUrl || "";
            if (authToken) {
              singletonAccountMap[namespace].authToken = authToken;
            }
            singletonAccountMap[namespace].namespace = response.namespacePrefix;
          }
          resolve(singletonAccountMap[namespace]);
        })
        .catch(e => {
          if (currentCounter === 0) {
            currentCounter = retryCounter;
            return reject(e);
          }
          currentCounter--;
          fetchAccountSDKAsync()
            .then(resolve)
            .catch(reject);
        });
    }
  });
}

function fetchUserDetails() {
  let userContext = null;
  return fetchUserContext()
    .then(response => {
      if (!response) {
        return null;
      }
      userContext = JSON.parse(response);
      return Promise.resolve(userContext);
    })
    .catch(e => {
      return Promise.reject(e);
    });
}

export async function getSDKPath(sdk) {
  let path = null;
  isCommunityPage = false
  switch (sdk) {
    case 'dcSDK':
      path = (isCommunityPage && enableProxySdk) ? '/latest/digitalcommerce/proxy/digitalcommerce/proxy.sdk.js' : '/latest/digitalcommerce/digitalcommerce.sdk.js';
      break;

    case 'translationSDK':
      path = (isCommunityPage && enableProxySdk) ? '/latest/translation/proxy/translation/proxy.sdk.js' : '/latest/translation/translation.sdk.js';
      break;

    case 'accountSDK':
      path = (isCommunityPage && enableProxySdk) ? '/latest/account/proxy/account/proxy.sdk.js' : '/latest/account/account.sdk.js';
      break;

    default:
      throw ("Error:: please specify sdk");
  }
  return path;
}