import { LightningElement, api, track } from 'lwc';
import componentTemplate from './vnosDcConfigureOfferSummary.html';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";

export default class vnosDcConfigureOfferSummary extends vnosDcBaseComponent(LightningElement) {

    @track _totalPrices = {};
    translatedLabelsObj = {};
    digitalCommerceSDK = null;
    @track _messages = [];
    showErrors = false;
    connectedCallback() {
        this.getSDKInstance();
        this.getTranslationLabels();
    }

    @api
    set totalPrices(val) {
        if (val) {
            this._totalPrices = val;
        }
    }
    get totalPrices() {
        return this._totalPrices;
    }

    @api
    set messages(val) {
        if (val) {
            this._messages = val;
        }
    }
    get messages() {
        return this._messages;
    }

    getSDKInstance() {
        this.getDigitalCommerceSDK()
            .then(sdkInstance => {
                if (sdkInstance) {
                    this.currencySymbol = sdkInstance.context.currencySymbol;
                    this.digitalCommerceSDK = sdkInstance;
                }
            })
            .catch(e => {
                console.log("Error in getting SDK instance ", e);
            });
    }

    getTranslationLabels() {
        const labelsToFetch = [
            "ALT_Action_AddToCart",
            "ALT_Label_OneTimeCharge",
            "ALT_Label_RecurringCharge",
            "ALT_Label_TotalOffer"
        ];
        this.fetchTranslatedLabels(labelsToFetch)
            .then(labels => {
                this.translatedLabelsObj = labels;
            }).catch(e => {
                console.log("Error in getting SDK instance ", e);
            });
    }

    addToCart() {
        console.log(this.messages);
        if (this.messages === null || this.messages.length === 0) {
            this.triggerAddToCartEvent();
        }
        else {
            //this.showErrors = true;
        }
    }

    triggerAddToCartEvent() {
        this.debounce(
            500,
            offer => {
                this.digitalCommerceSDK &&
                    this.digitalCommerceSDK.fire(
                        "vlocity-dc-add-to-cart",
                        "result",
                        offer
                    );
            },
            null
        );
    }

    render() {
        return componentTemplate;
    }

}