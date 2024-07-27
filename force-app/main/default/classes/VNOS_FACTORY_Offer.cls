public class VNOS_FACTORY_Offer {
  @TestVisible
  private static final String CONST_PROMOTION = 'Promotion';
  @TestVisible
  private static final String CONST_OFFER_TYPE = 'offerType';

  public static VNOS_DOMAIN_Offer createOffer(Map<String, Object> offer) {
    String offerType = String.valueOf(offer.get(CONST_OFFER_TYPE));
    if (CONST_PROMOTION.equals(offerType)) {
      return new VNOS_DOMAIN_Promotion(offer);
    } else {
      return new VNOS_DOMAIN_Product(offer);
    }
  }
}