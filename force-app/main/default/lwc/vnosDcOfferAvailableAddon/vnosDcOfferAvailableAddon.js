import { LightningElement, api, track } from 'lwc';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import componentTemplate from "./vnosDcOfferAvailableAddon.html";

export default class vnosDcOfferAvailableAddon extends vnosDcBaseComponent(LightningElement) {

    @track _childProduct;
    @track priceInfo = [];
    productImage = "";
    @track translatedLabelsObj = {};
    digitalCommerceSDK = null;
    digitalTranslationSDK = null;
    @track prices = {};

    connectedCallback() {
        this.getSDKInstance();
        this.getTranslationLabels();
        if (JSON.stringify(this.priceInfo.recurringChargeInfo) !== "{}") {
            this.prices = {
                paymentType: "mês",
                price: this.priceInfo.recurringChargeInfo.displayText,
                isRecurring: false
            };
        }
        else if (JSON.stringify(this.priceInfo.oneTimeChargeInfo) !== "{}") {
            this.prices = {
                paymentType: "",
                price: this.priceInfo.oneTimeChargeInfo.displayText,
                isRecurring: true
            };
        }
        else {
            this.prices = {
                paymentType: "",
                price: null,
                isRecurring: false
            };
        }
        /*if (JSON.stringify(this.priceInfo.recurringChargeInfo) !== "{}") {
            if (this.priceInfo.recurringChargeInfo.recurringCharge === 0 && JSON.stringify(this.priceInfo.oneTimeChargeInfo) !== "{}") {
                this.prices = {

                    paymentType: "",
                    price: this.priceInfo.oneTimeCharge === 0 ? "€0" : "€" + this.priceInfo.oneTimeCharge,
                    isRecurring: false
                };
                if (this.priceInfo.oneTimeChargeInfo.adjustments.length > 0) {
                    this.hasAdjustment = true;
                    this.adjustment = { label: this.priceInfo.oneTimeChargeInfo.adjustments[0].DisplayText__c, base: '€' + this.priceInfo.oneTimeChargeInfo.baseamount, value: this.priceInfo.oneTimeChargeInfo.adjustments[0].AdjustmentValue__c + '%' }
                }
                this.prices.price = '€' + this.priceInfo.oneTimeChargeInfo.oneTimeCharge;
            }
            else {
                this.prices = {
                    paymentType: "mès",
                    price: this.priceInfo.recurringChargeInfo.recurringCharge === 0 || this.priceInfo.recurringChargeInfo.recurringCharge === null ? "€0" : "€" + this.priceInfo.recurringChargeInfo.recurringCharge,
                    isRecurring: true
                };
            }
        }*/
    }

    @api
    set childProduct(val) {
        if (val) {
            this._childProduct = val;
            this.productImage =
                this.childProduct.attachments && this.childProduct.attachments.length
                    ? this.childProduct.attachments[0].url
                    : "";
            this.priceInfo = this.childProduct.priceInfo;
        }
    }
    get childProduct() {
        return this._childProduct;
    }

    get canAdd() {
        if (this.childProduct.customFields.hasOwnProperty('ALT_PROD_SEL_ProcessTags__c'))
            return this.childProduct.customFields.ALT_PROD_SEL_ProcessTags__c === null;
        return true;
    }

    get show() {
        if (this.childProduct.customFields.hasOwnProperty('ALT_PROD_SEL_ProcessTags__c'))
            return this.childProduct.customFields.ALT_PROD_SEL_ProcessTags__c !== "PromoOnly";
        return true;
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
            "ALT_Action_Add"
        ];
        this.fetchTranslatedLabels(labelsToFetch)
            .then(labels => {
                this.translatedLabelsObj = labels;
            }).catch(e => {
                console.log("Error in getting SDK instance ", e);
            });
    }

    updateAddon(event) {
        let currentChildOffer = JSON.parse(JSON.stringify(this.childProduct));
        currentChildOffer.quantity = 1;
        this.triggerSaveChildOfferEvent(currentChildOffer);

    }

    triggerSaveChildOfferEvent(childProduct) {
        this.debounce(
            500,
            offer => {
                this.digitalCommerceSDK &&
                    this.digitalCommerceSDK.fire(
                        "vlocity-dc-save-child-offers",
                        "result",
                        offer
                    );
            },
            childProduct
        );
    }

    /*get getComputedClass() {
        return (
            (this.isLoading ? " nds-dc-addon-loading" : "")
        );
    }*/

    render() {
        return componentTemplate;
    }
}