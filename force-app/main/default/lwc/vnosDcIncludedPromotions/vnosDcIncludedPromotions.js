import { LightningElement, api, track } from 'lwc';
import componentTemplate from './vnosDcIncludedPromotions.html';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";


export default class vnosDcIncludedPromotions extends vnosDcBaseComponent(LightningElement) {

    @track _promotions;
    @track includedPromos;
    translatedLabelsObj = {};
    digitalCommerceSDK = null;

    @api
    get promotions() {
        return this._promotions;
    }
    set promotions(data) {
        try {

            if (data) {
                this._promotions = JSON.parse(JSON.stringify(data));
            }
        } catch (err) {
            console.error("Error in set promotions() -> " + err);
        }
    }

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
            "ALT_Label_AppliedPromotions"
        ];
        this.fetchTranslatedLabels(labelsToFetch)
            .then(labels => {
                this.translatedLabelsObj = labels;
            }).catch(e => {
                console.log("Error in getting SDK instance ", e);
            });
    }

    render() {
        return componentTemplate;
    }
}