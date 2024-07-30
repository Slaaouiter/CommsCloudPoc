import { api, LightningElement, track } from "lwc"
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin"
import { fetchCustomLabels, getUserProfile } from "vlocity_cmt/utility"

export default class VnosOfferCardFooter extends OmniscriptBaseMixin(
  LightningElement
) {
  @track
  _translatedCustomLabels = {}

  @api
  isGrouped

  @api
  products

  @api
  autoAppliedPromotionsBelowFirstAttribute;


  @track
  _selectedProduct = {}

  @api
  get selectedProduct() {
    return this._selectedProduct
  }

  set selectedProduct(product) {
    if (product) {
      this._selectedProduct = JSON.parse(JSON.stringify(product))
      // if (this._attributeCodeToIconPosition) {
      //   this.updateAttributesWithStyleInformation()
      // }
    }
  }

  async connectedCallback() {
    this.fetchTranslatedCustomLabels()
  }

  async fetchTranslatedCustomLabels() {
    const userProfile = await getUserProfile()
    const ALT_Label_Offer = "ALT_Label_Offer"

    try {
      this._translatedCustomLabels = await fetchCustomLabels(
        [ALT_Label_Offer],
        userProfile?.language || "pt_PT"
      )
    } catch (error) {
      console.error(
        "A problem occurred while fetching for the custom labels ==> the full error" +
          error
      )
    }
  }

  get offerLabel() {
    return "Offer"//this._translatedCustomLabels.ALT_Label_Offer || "Offerta"
  }

  get hasAutoAppliedPromotionsBelowFirstAttributes() {
    return this.autoAppliedPromotionsBelowFirstAttribute;
  }

  get filteredCommercialAttributes() {
    const excludedValue = "Unica"

    const commercialAttributes =
      this._selectedProduct?.commercialAttributesComingFromMatrix || []

    return commercialAttributes?.filter(
      (attribute) => attribute.value && attribute.value !== excludedValue
    )
  }

  selectOption(event) {
    if (event?.detail) {
      let customEvent = new CustomEvent("selectoption", {
        detail: event.detail,
      })
      this.dispatchEvent(customEvent)
    }
  }
}