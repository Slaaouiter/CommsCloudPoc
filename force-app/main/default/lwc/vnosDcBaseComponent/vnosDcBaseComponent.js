import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
//import digitalcommerce from "/resource/vlocity_cmt__vlocitydcsdk";
//import account from "/resource/vlocity_cmt__vlocityaccountsdk";
//import firebase from "/resource/vlocity_cmt__dc_firebase";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import translation from "/resource/vlocity_cmt__vlocitysdk";
import { getLabels, addCustomLabels } from "c/vnosDcCustomLabels";
import { api, track } from "lwc";
import { load as loadNewport } from "vlocity_cmt/newportLoader";
import {
  isDCSDKInstanceAvailable,
  isTranslationSDKInstanceAvailable,
  isAccountSDKInstanceAvailable,
  getSDKInstance,
  getTranslationSDKInstance,
  getAccountSDKInstance,
  setApiUrl,
  setAuthToken,
  setCustomSalesforceUrl,
  setCheckoutNodeServerUrl,
  setSecureServerRequestCredentials,
  getSDKPath,
  loadResources,
  setEnableProxySdk
} from "c/vnosDcSDKFactory";
import { setAuthConfiguration } from "c/vnosDcCustomAuthenticationUtil";


/**
 * @class DCBaseComponent
 * @extends {OmniscriptBaseMixin} Extend the OmniscriptBaseMixin base class
 *
 * @classdesc
 * DCBaseComponent is a base class which is extended by all lightning web components.<br/><br/>
 *
 * Note: By default ProxySDK will be disabled in community page.To enable ProxySDK please pass enableProxySdk = true as attribute.
 * 
 * <b>DCBaseComponent methods</b> <br/>
 *
 * 1.Method to get digital commerce SDK instance.<br/>
 * 2.Method to show toast<br/>
 * 3.Debounce method<br/>
 * 4.Method to update OmniScript data JSON<br/>
 *
 */
export const vnosDcBaseComponent = Base =>
  class extends OmniscriptBaseMixin(Base) {
    timer = null;
    retryCounter = 3;
    sdkInstance = null;
    namespace = "";
    _accountId = null;
    _authConfiguration = null;
    @track _enableProxySdk = false;

    @api
    set authConfiguration(val) {
      if (val) {
        this._authConfiguration = val;
        setAuthConfiguration(val);
      }
    }
    get authConfiguration() {
      return this._authConfiguration;
    }

    @api
    set enableProxySdk(val) {
      if (val || val !== "") {
        this._enableProxySdk = val;
        setEnableProxySdk(val);
      }
    }
    get enableProxySdk() {
      return this._enableProxySdk;
    }

    set updateApiUrl(url) {
      if (url) {
        setApiUrl(url);
      }
    }

    set updateAuthToken(authToken) {
      if (authToken) {
        setAuthToken(authToken);
      }
    }

    set checkoutNodeServerUrl(url) {
      if (url) {
        setCheckoutNodeServerUrl(url);
      }
    }

    set secureServerRequestCredentials(requestCredential) {
      if (requestCredential) {
        setSecureServerRequestCredentials(requestCredential);
      }
    }

    set updateNamespace(namespace) {
      if (namespace) {
        this.namespace = namespace;
      }
    }

    @api
    set accountId(val) {
      if (val) {
        this._accountId = val;
      }
    }

    get accountId() {
      return this._accountId;
    }

    /** This function gets digital commerce sdk instance
     * @param {string} namespace -  org namespace.
     * @return SDK instance.
     * @memberof DCBaseComponent
     */
    async getDigitalCommerceSDK(namespace) {
      await loadResources(this);
      //console.log('@@SARB getDigitalCommerceSDK... ', namespace);
      return new Promise((resolve, reject) => {
        if (isDCSDKInstanceAvailable(namespace)) {
          this.sdkInstance = getSDKInstance(namespace, this);
          //console.log('@@SARB getDigitalCommerceSDK sdkInstance: ', this.sdkInstance);
          resolve(this.sdkInstance);
        } else {
          //console.log('@@SARB getDigitalCommerceSDK firebase...');
          getSDKInstance(namespace, this)
            .then(response => {
              if (response && this.namespace) {
                response.namespace = this.namespace;
              }
              this.sdkInstance = response;
              //console.log('@@SARB getDigitalCommerceSDK sdkInstance: ', response);
              resolve(response);
            })
            .catch(e => {
              reject(e);
              //console.log('@@SARB getDigitalCommerceSDK reject 1: ', e);
              return;
            });
          /*getSDKPath("dcSDK").then((sdkPath) => {
            Promise.all([
              loadScript(
                this,
                "/resource/vlocity_cmt__vlocitydcsdk" + sdkPath
              ),
              loadScript(
                this,
                "/resource/vlocity_cmt__dc_firebase" + "/firebase-app.js"
              ),
              loadScript(
                this,
                "/resource/vlocity_cmt__dc_firebase" + "/firebase-auth.js"
              ),
              loadNewport(this)
            ])
              .then(() => {
                getSDKInstance(namespace)
                  .then(response => {
                    if (response && this.namespace) {
                      response.namespace = this.namespace;
                    }
                    this.sdkInstance = response;
                    //console.log('@@SARB getDigitalCommerceSDK sdkInstance: ', response);
                    resolve(response);
                  })
                  .catch(e => {
                    reject(e);
                    //console.log('@@SARB getDigitalCommerceSDK reject 1: ', e);
                    return;
                  });
              })
              .catch(e => {
                if (this.currentCounter === 0) {
                  reject(e);
                  //console.log('@@SARB getDigitalCommerceSDK reject 2: ', e);
                  return;
                }
                this.retryCounter--;
                this.getDigitalCommerceSDK(namespace)
                  .then(resolve)
                  .catch(reject);
              });
          });*/
        }
      });
    }

    /** This function gets translation sdk instance
     * @param {string} namespace -  org namespace.
     * @return SDK instance.
     * @memberof DCBaseComponent
     */
    getTranslationSDK(namespace) {
      return new Promise((resolve, reject) => {
        if (isTranslationSDKInstanceAvailable(namespace)) {
          resolve(getTranslationSDKInstance(namespace));
        } else {
          getTranslationSDKInstance(namespace)
            .then(response => {
              if (response && this.namespace) {
                response.namespace = this.namespace;
              }
              resolve(response);
            })
            .catch(e => {
              reject(e);
              return;
            });
        }
      });
    }

    /** This function gets digital commerce sdk instance
     * @param {string} namespace -  org namespace.
     * @return SDK instance.
     * @memberof DCBaseComponent
     */
    getAccountSDK(namespace) {
      return new Promise((resolve, reject) => {
        if (isAccountSDKInstanceAvailable(namespace)) {
          resolve(getAccountSDKInstance(namespace));
        } else {
          getAccountSDKInstance(namespace)
            .then(response => {
              if (response && this.namespace) {
                response.namespace = this.namespace;
              }
              resolve(response);
            })
            .catch(e => {
              reject(e);
              return;
            });
        }
      });
    }

    /** This function retrieves translated labels for given language
     * @param {String} language - optional parameter - language
     * @param {Array<String>} labels - array of labels
     * @return tranlated labels.
     * @memberof DCBaseComponent
     */
    fetchTranslatedLabels(labels, language) {
      let translatedLabelsObj = {};
      return new Promise((resolve, reject) => {
        if (labels) {
          this.getTranslationSDK()
            .then(translationSDK => {
              if (!translationSDK) {
                resolve(translatedLabelsObj);
                return;
              }
              if (!language) {
                language = translationSDK.language;
              }
              getLabels(translationSDK, language)
                .then(res => {
                  labels.forEach(label => {
                    translatedLabelsObj[label] = translationSDK.translate(
                      label
                    );
                  });
                  resolve(translatedLabelsObj);
                })
                .catch(e => {
                  reject(e);
                  return;
                });
            })
            .catch(e => {
              reject(e);
              return;
            });
        } else {
          reject("Error: Missing labels parameter");
          return;
        }
      });
    }

    /** This function adds more labels to the existing labels array
     * @param {Array<String>} labels - array of labels
     * @memberof DCBaseComponent
     */
    addNewCustomLabels(labels) {
      addCustomLabels(labels);
    }

    /** This function is used to show toast messages
     * @param {string} title -  toast message title.
     * @param {string} message -  toast message content.
     * @param {string} variant - info, success, warning, error
     * @param {string} parent
     * @return SDK instance.
     * @memberof DCBaseComponent
     */
    showToast(title, message, variant, parent) {
      const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: "dismissable"
      });
      parent.dispatchEvent(event);
    }

    /**
     * Method to update custom custom salesforce domain url
     * @param {String} url - user custom domain url
     * @memberof DCBaseComponent
     */
    customDomainUrl(url) {
      if (url) {
        setCustomSalesforceUrl(url);
      }
    }

    /** This function creates and returns a new debounced version of the passed function that will postpone
     * its execution until after wait milliseconds have elapsed since the last time it was invoked.
     * @param {string} wait -  execution wait time in milliseconds.
     * @param {Function} func -  function for which execution needs to be delayed.
     * @param {string} args - parameters of the passed function
     * @memberof DCBaseComponent
     */
    debounce(wait, func, args) {
      if (this.timer) {
        clearTimeout(this.timer);
      }
      let params = args;
      this.timer = setTimeout(() => {
        func(params);
        this.timer = null;
      }, wait);
    }

    /** This function updates OmniScript data JSON
     * @param {string} obj -  JSON object to be updated in omniscript.
     * @memberof DCBaseComponent
     */
    updateOmniScriptDataJson(obj) {
      this.omniUpdateDataJson(obj);
    }

    /** This function to check whether given object has empty values or not
     * @param {Object} obj
     * @memberof DCBaseComponent
     */
    checkProperties(obj) {
      for (var key in obj) {
        if (obj[key] === null || obj[key] === "") return false;
      }
      return true;
    }

    get isOmniScriptLoaded() {
      return this.omniJsonDef;
    }

    /** This function to check whether given object has empty values or not
     * @param {Object} sdk
     * @param {Object} input {path:'',httpMethod:'',payload:{}}
     * @param {number} timeoutInMillis
     * @memberof DCBaseComponent
     */
    invokeAPI(sdkInstance, input, timeoutInMillis) {
      return new Promise((resolve, reject) => {
        timeoutInMillis = timeoutInMillis || 20000;
        let restOptions = {
          retryCount: 3,
          reload: false,
          url: input.path,
          timeoutInMillis: timeoutInMillis,
          options: {
            method: input.httpMethod
          }
        };
        if (input.httpMethod === "POST" || input.httpMethod === "PUT") {
          restOptions.options = Object.assign(
            {},
            {
              body: JSON.stringify(input.payload),
              method: input.httpMethod,
              headers: {
                "Content-Type": "application/json"
              }
            }
          );
        }

        sdkInstance.datasource
          .rest(restOptions)
          .execute()
          .then(result => {
            resolve(result);
          })
          .catch(error => {
            reject(error);
            return;
          });
      });
    }

    /** Function to find out the matching product group for given id's path.
     * @param {string} hierarchyPath
     * @param {Object} productGroups
     * @memberof DCBaseComponent
     */
    findProductGroup(hierarchyPath, productGroups) {
      try {
        for (const productGroup of productGroups) {
          if (productGroup.id === hierarchyPath[0]) {
            if (productGroup.childProducts) {
              return productGroup;
            } else if (productGroup.productGroups) {
              return this.findProductGroup(
                hierarchyPath.slice(1),
                productGroup.productGroups
              );
            }
          }
        }
      } catch (e) {
        console.log("error while finding product group", e);
        return null;
      }
    }

    /** Function to auto-advance the omniscript step
     * @param {string} stepName - optional
     * @memberof DCBaseComponent
     */
    advanceOSNextStep(stepName) {
      if (stepName) {
        this.omniNavigateTo(stepName);
      } else {
        this.omniNextStep();
      }
    }

    /** Function to fetch the query params from the current URL.
     * @memberof DCBaseComponent
     */
    fetchURLParams() {
      let params = {};
      let queryParams = "";
      let search = window.location.search.substring(1);
      if (search && search.split("=").length > 1) {
        search = decodeURIComponent(search.split("=")[1]);
        search = search.split("/");
        search &&
          search.length > 1 &&
          search.forEach((val, index) => {
            if (index % 2 !== 0) {
              queryParams += "=" + val + "&";
            } else {
              queryParams += val;
            }
          });
        queryParams = queryParams.slice(0, -1);
      }
      if (queryParams !== "") {
        params = JSON.parse(
          '{"' + queryParams.replace(/&/g, '","').replace(/=/g, '":"') + '"}',
          (key, value) => {
            return key === "" ? value : decodeURIComponent(value);
          }
        );
      }
      return params;
    }

    /** Function to fetch all promotions as list
     * @memberof DCBaseComponent
     */
    getPromotions(asset) {
      if (asset.promotions && asset.promotions.length) {
        let promotions = "";
        const len = asset.promotions.length;
        asset.promotions.forEach((promotion, index) => {
          promotions += promotion.name + (index < len - 1 ? ", " : "");
        });
        return promotions;
      } else {
        return "";
      }
    }

    @api
    fire(eventName, action, payload) {
      this.sdkInstance && this.sdkInstance.fire(eventName, action, payload);
    }
    @api
    register(eventName, cb) {
      this.sdkInstance && this.sdkInstance.register(eventName, cb);
    }
  };