import { api, LightningElement, track } from "lwc"
import { fetchCustomLabels, getUserProfile } from "vlocity_cmt/utility"
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin"

export default class VnosOfferCardHeader extends OmniscriptBaseMixin(
  LightningElement
) {
  @track
  _translatedCustomLabels = {}

  @api
  hasLoyalty

  @api
  isLoyaltyPossible

  @api
  promotions

  @api
  autoAppliedPromotionsAtTop

  @api
  productName

  async connectedCallback() {
    await this.fetchTranslatedCustomLabels()
    this.initializeLoyaltyOptions()
  }

  async fetchTranslatedCustomLabels() {
    const userProfile = await getUserProfile()

    const ALT_Label_WithLoyalty = "ALT_Label_WithLoyalty"
    const ALT_Label_WithoutLoyalty = "ALT_Label_WithoutLoyalty"

    try {
      this._translatedCustomLabels = await fetchCustomLabels(
        [ALT_Label_WithLoyalty, ALT_Label_WithoutLoyalty],
        userProfile?.language || "pt_PT"
      )
    } catch (error) {
      console.error(
        "A problem occurred while fetching for the custom labels ==> the full error" +
          error
      )
    }
  }

  initializeLoyaltyOptions() {
    this.options = [
      {
        label: this.withLoyaltyLabel,
        value: true,
      },
      {
        label: this.withoutLoyaltyLabel,
        value: false,
      },
    ]
  }

  get withLoyaltyLabel() {
    return this._translatedCustomLabels.ALT_Label_WithLoyalty
  }

  get withoutLoyaltyLabel() {
    return this._translatedCustomLabels.ALT_Label_WithoutLoyalty
  }

  get hasAutoAppliedPromotionsAtTop() {
    return this.autoAppliedPromotionsAtTop
  }

  handleLoyaltyOptionChange(event) {
    if (event?.target) {
      const isChecked = event.target.checked
      let customEvent = new CustomEvent("loyaltyoptionchange", {
        detail: isChecked,
      })
      this.dispatchEvent(customEvent)
    }
  }
}
