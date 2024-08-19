import { api, LightningElement, track } from "lwc"
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin"
import { fetchCustomLabels, getUserProfile } from "vlocity_cmt/utility"

export default class VnosOfferCardBody extends OmniscriptBaseMixin(
  LightningElement
) {
  @track
  _translatedCustomLabels = {}

  @track
  _autoAppliedPromotionsAtBrowseOffer = []

  @api
  initialAmountText

  @api
  amountText

  @api
  get autoAppliedPromotionsAtBrowseOffer() {
    return this._autoAppliedPromotionsAtBrowseOffer
  }

  set autoAppliedPromotionsAtBrowseOffer(promotions) {
    if (promotions) {
      let autoAppliedPromotionsAtBrowseOffer = JSON.parse(
        JSON.stringify(promotions)
      )

      autoAppliedPromotionsAtBrowseOffer?.forEach((promotion) => {
        promotion.chargeAmountText =
          "€" +
          Math.abs(promotion.chargeAmount) +
          (promotion.hasRecurringCharge ? this.perMonthLabel : "")
      })
      this._autoAppliedPromotionsAtBrowseOffer =
        autoAppliedPromotionsAtBrowseOffer
    }
  }

  @api
  autoAppliedPromotionsAtCenter

  connectedCallback() {
    this.fetchTranslatedCustomLabels()
  }

  async fetchTranslatedCustomLabels() {
    const userProfile = await getUserProfile()

    const ALT_Action_Join = "ALT_Action_Join"
    const ALT_Label_MembershipAdvantage = "ALT_Label_MembershipAdvantage"
    const ALT_Label_PerMonth = "ALT_Label_PerMonth"

    try {
      this._translatedCustomLabels = await fetchCustomLabels(
        [ALT_Action_Join, ALT_Label_MembershipAdvantage, ALT_Label_PerMonth],
        userProfile?.language || "pt_PT"
      )
    } catch (error) {
      console.error(
        "A problem occurred while fetching for the custom labels ==> the full error" +
          error
      )
    }
  }

  get joinLabel() {
    return 'Join'//this._translatedCustomLabels.ALT_Action_Join || "Aderir"
  }
  get perMonthLabel() {
    return '/month'//this._translatedCustomLabels.ALT_Label_PerMonth || "/mês"
  }

  get membershipAdvantageLabel() {
    return 'Membership Advantage'
    // return (
    //   this._translatedCustomLabels.ALT_Label_MembershipAdvantage ||
    //   "Vantagens de adesão"
    // )
  }

  get hasAutoAppliedPromotionsAtCenter() {
    return (
      this.autoAppliedPromotionsAtCenter &&
      this.autoAppliedPromotionsAtCenter.length > 0
    )
  }

  join() {
    let customEvent = new CustomEvent("selectproduct", {})
    this.dispatchEvent(customEvent)
  }
}