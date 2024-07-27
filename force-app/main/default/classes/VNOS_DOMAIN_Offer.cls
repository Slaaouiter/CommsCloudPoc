public virtual class VNOS_DOMAIN_Offer {
  @TestVisible
  private static final String CONST_OFFER_TYPE = 'offerType';
  @TestVisible
  private static final String CONST_PROMOTION = 'Promotion';

  public String offerType;

  public VNOS_DOMAIN_Offer() {
  }
  public VNOS_DOMAIN_Offer(Map<String, Object> offer) {
    this.offerType = String.valueOf(offer.get(CONST_OFFER_TYPE));
  }
}