import { LightningElement, track, api } from "lwc"
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin"
import {
  fetchCustomLabels,
  getUserProfile,
} from "vlocity_cmt/utility"

export default class VnosOffersList extends OmniscriptBaseMixin(
  LightningElement
) {
  @track
  _translatedCustomLabels = {}

  @api
  catalog

  connectedCallback() {
    this.fetchTranslatedCustomLabels()
  }

  async fetchTranslatedCustomLabels() {
    const userProfile = await getUserProfile()
    const vlocity_cmt__OmnipreviousLabel = "vlocity_cmt__OmnipreviousLabel"

    try {
      this._translatedCustomLabels = await fetchCustomLabels(
        [vlocity_cmt__OmnipreviousLabel],
        userProfile?.language || "pt_PT"
      )
    } catch (error) {
      console.error(
        "A problem occurred while fetching for the custom labels ==> the full error" +
          error
      )
    }
  }

  get previousLabel() {
    return this._translatedCustomLabels.vlocity_cmt__OmnipreviousLabel || "Anterior"
  }

  selectOffer(event) {
    if (event && event.detail) {
      this.omniUpdateDataJson({
        selectedProduct: event.detail,
      })
      //this.emptyConfigureOfferStepState()
      this.omniNextStep()
    }
  }

  emptyConfigureOfferStepState() {
    const key = "ConfigureOffer"
    const usePubSub = true
    this.omniSaveState(null, key, usePubSub)
  }

  previous() {
    this.omniPrevStep()
  }
}
