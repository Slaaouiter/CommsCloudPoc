import { LightningElement, api, track } from 'lwc';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import componentTemplate from "./vnosDcOfferIncludedAddon.html";

export default class vnosDcOfferIncludedAddon extends vnosDcBaseComponent(LightningElement) {

    @track _childProduct;
    productImage = "";
    @track translatedLabelsObj = {};
    digitalCommerceSDK = null;
    digitalTranslationSDK = null;
    @track attributes = [];
    @track priceInfo;
    comboboxQuantityRange = {};

    connectedCallback() {
        this.getSDKInstance();
        this.getTranslationLabels();
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
            "ALT_Label_Quantity",
            "ALT_Action_Remove"
        ];
        this.fetchTranslatedLabels(labelsToFetch)
            .then(labels => {
                this.translatedLabelsObj = labels;
            }).catch(e => {
                console.log("Error in getting SDK instance ", e);
            });
    }

    @api
    set childProduct(val) {
        if (val) {
            this._childProduct = val;
            this.productImage =
                this.childProduct.attachments && this.childProduct.attachments.length
                    ? this.childProduct.attachments[0].url
                    : "";
            this.comboboxQuantityRange = Array.from({ length: this.childProduct.maxQuantity }, (v, k) => ({ label: k + 1, value: k + 1 }));
            this.attributes = Object.values(this.childProduct.attributes)[0];
            this.priceInfo = this.childProduct.priceInfo;
        }
    }
    get childProduct() {
        return this._childProduct;
    }

    get canRemove() {
        if (this.childProduct.customFields.hasOwnProperty('ALT_PROD_SEL_ProcessTags__c'))
            return this.childProduct.minQuantity === 0 && this.childProduct.customFields.ALT_PROD_SEL_ProcessTags__c === null;
        return this.childProduct.minQuantity === 0
    }

    get quantity() {
        return this.childProduct.quantity;
    }

    get disabled() {
        return this.childProduct.maxQuantity === 1;
    }

    removeAddon(event) {
        let currentChildOffer = JSON.parse(JSON.stringify(this.childProduct));
        currentChildOffer.quantity = 0;
        this.triggerSaveChildOfferEvent(currentChildOffer);

    }

    handleQtyChange(event) {
        let currentChildOffer = JSON.parse(JSON.stringify(this.childProduct));
        currentChildOffer.quantity = event.target.value;
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