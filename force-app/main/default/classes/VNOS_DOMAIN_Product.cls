public class VNOS_DOMAIN_Product extends VNOS_DOMAIN_Offer implements Comparable {
  @TestVisible
  private final static String CONST_NAME = 'Name';
  @TestVisible
  private final static String CONST_PRICE_RESULT = 'priceResult';
  @TestVisible
  private final static String CONST_CODE = 'ProductCode';
  @TestVisible
  private final static String CONST_ATTRIBUTE_CATEGORY = 'AttributeCategory';
  @TestVisible
  private static final String CONST_ORDER_OF_GROUP = 'orderOfGroup';
  @TestVisible
  private static final String CONST_ORDER_IN_GROUP = 'orderInGroup';
  @TestVisible
  private final static String CONST_PUBLIC_OFFER_NAME = 'PublicOfferName';
  @TestVisible
  private final static String CONST_COMMERCIAL_DESCRIPTION = 'CommercialDescription';
  @TestVisible
  private final static String CONST_OFFER_VARIANT_CODE = 'OfferVariantCode';

  @TestVisible
  private static final String OUTPUT_NAME = 'name';
  @TestVisible
  private static final String OUTPUT_CODE = 'code';
  @TestVisible
  private static final String OUTPUT_COMMERCIAL_ATTRIBUTES_COMING_FROM_MATRIX = 'commercialAttributesComingFromMatrix';
  @TestVisible
  private static final String OUTPUT_FIRST_COMMERCIAL_ATTRIBUTE = 'firstCommercialAttribute';
  @TestVisible
  private static final String OUTPUT_AMOUNT = 'amount';
  @TestVisible
  private static final String OUTPUT_AMOUNT_TEXT = 'amountText';
  @TestVisible
  private static final String OUTPUT_INITIAL_AMOUNT = 'initialAmount';
  @TestVisible
  private static final String OUTPUT_INITIAL_AMOUNT_TEXT = 'initialAmountText';
  @TestVisible
  private static final String OUTPUT_AUTO_APPLIED_PROMOTIONS = 'autoAppliedPromotions';
  @TestVisible
  private static final String OUTPUT_AUTO_APPLIED_PROMOTIONS_AT_BROWSE_OFFER = 'autoAppliedPromotionsAtBrowseOffer';
  @TestVisible
  private static final String OUTPUT_PROMOTIONS = 'promotions';
  @TestVisible
  private static final String OUTPUT_HAS_RECURRING_CHARGE = 'hasRecurringCharge';
  @TestVisible
  private static final String OUTPUT_OFFER_VARIANT_CODE = 'offerVariantCode';

  public Map<String, Object> node = new Map<String, Object>();

  public VNOS_DOMAIN_Prices prices = new VNOS_DOMAIN_Prices();
  public VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes();
  public VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();

  @TestVisible
  private VNOS_DOMAIN_Product() {
  }

  public VNOS_DOMAIN_Product(Map<String, Object> product) {
    if (product != null) {
      this.node = product;
      if (
        product.containsKey(CONST_PRICE_RESULT) &&
        product.get(CONST_PRICE_RESULT) instanceof List<Object>
      ) {
        this.prices = new VNOS_DOMAIN_Prices(
          (List<Object>) product.get(CONST_PRICE_RESULT)
        );
      }
      if (
        product.containsKey(CONST_ATTRIBUTE_CATEGORY) &&
        product.get(CONST_ATTRIBUTE_CATEGORY) instanceof Map<String, Object>
      ) {
        this.attributes = new VNOS_DOMAIN_CommercialAttributes(
          (Map<String, Object>) product.get(CONST_ATTRIBUTE_CATEGORY)
        );
      }
      if (product.containsKey(OUTPUT_PROMOTIONS)) {
        this.promotions = new VNOS_DOMAIN_Promotions(
          (List<Object>) product.get(OUTPUT_PROMOTIONS)
        );
      }
    }
  }

  public String code() {
    return String.valueOf(node.get(CONST_CODE));
  }
  public String name() {
    return String.valueOf(node.get(CONST_NAME));
  }
  public void name(String name) {
    node.put(CONST_NAME, name);
  }

  public String publicOfferName() {
    return String.valueOf(node.get(CONST_PUBLIC_OFFER_NAME));
  }
  public void publicOfferName(String publicOfferName) {
    node.put(CONST_PUBLIC_OFFER_NAME, publicOfferName);
  }

  public String commercialDescription() {
    return String.valueOf(node.get(CONST_COMMERCIAL_DESCRIPTION));
  }
  public void commercialDescription(String commercialDescription) {
    node.put(CONST_COMMERCIAL_DESCRIPTION, commercialDescription);
  }
  public void offerVariantCode(String offerVariantCode) {
    node.put(CONST_OFFER_VARIANT_CODE, offerVariantCode);
  }
  public String offerVariantCode() {
    return String.valueOf(node.get(CONST_OFFER_VARIANT_CODE));
  }
  public Boolean hasOfferVariantCode() {
    return String.isNotBlank(offerVariantCode());
  }
  public Integer orderOfGroup() {
    Integer orderOfGroup = 0;
    try {
      orderOfGroup = Integer.valueOf(node.get(CONST_ORDER_OF_GROUP));
    } catch (Exception e) {
      System.debug('order of group is not an integer ' + orderOfGroup);
    }
    return orderOfGroup;
  }
  public void orderOfGroup(Integer orderOfGroup) {
    node.put(CONST_ORDER_OF_GROUP, orderOfGroup);
  }

  public Integer orderInGroupe() {
    Integer orderInGroupe = 0;
    try {
      orderInGroupe = Integer.valueOf(node.get(CONST_ORDER_IN_GROUP));
    } catch (Exception e) {
      System.debug('order in group is not an integer ' + orderInGroupe);
    }
    return orderInGroupe;
  }

  public void orderInGroupe(Integer orderInGroupe) {
    node.put(CONST_ORDER_IN_GROUP, orderInGroupe);
  }

  public void promotions(VNOS_DOMAIN_Promotions promotions) {
    this.promotions = promotions;
    node.put(OUTPUT_PROMOTIONS, promotions.toResponse());
  }

  public void updateFromMatrixRow(VNOS_DOMAIN_AttributePricingMatrixRow row) {
    name(row.itemName);
    orderInGroupe(row.getOrderInGroup());
    orderOfGroup(row.getOrderForGroup());
    attributes.updateFromMatrixRow(row);
    prices.updateAmountsFromMatrixRow(row);
    publicOfferName(row.publicOfferName);
    commercialDescription(row.commercialDescription);
    offerVariantCode(row.offerVariantCode);
  }

  public void autoApplyPromotionsAtBrowseOffer() {
    VNOS_DOMAIN_Promotions autoAppliedPromotionsAtBrowseOffer = promotions.getAutoAppliedPromotionsAtBrowseOffer();
    VNOS_DOMAIN_Price price = prices.getPrice();
    price.initialAmount(price.amount());
    for (
      VNOS_DOMAIN_Promotion promotion : autoAppliedPromotionsAtBrowseOffer.elements
    ) {
      price.applyPromotion(promotion);
    }
  }

  public void applyVAT() {
    prices.getPrice().applyVAT();
  }

  public Integer compareTo(Object compareTo) {
    VNOS_DOMAIN_Product compareToProduct = (VNOS_DOMAIN_Product) compareTo;
    return orderInGroupe() == compareToProduct.orderInGroupe()
      ? 0
      : (orderInGroupe() > compareToProduct.orderInGroupe() ? 1 : -1);
  }

  public Map<String, Object> toResponse() {
    Map<String, Object> response = new Map<String, Object>();
    response.put(OUTPUT_NAME, name());
    response.put(OUTPUT_CODE, code());
    response.put(CONST_ORDER_OF_GROUP, orderOfGroup());
    response.put(CONST_ORDER_IN_GROUP, orderInGroupe());
    response.put(CONST_PUBLIC_OFFER_NAME, publicOfferName());
    response.put(CONST_COMMERCIAL_DESCRIPTION, commercialDescription());

    VNOS_DOMAIN_CommercialAttributes commercialAttributesComingFromMatrix = attributes.getCommercialAttributesComingFromMatrix();
    commercialAttributesComingFromMatrix.elements.sort();
    if (!commercialAttributesComingFromMatrix.elements.isEmpty()) {
      response.put(
        OUTPUT_FIRST_COMMERCIAL_ATTRIBUTE,
        commercialAttributesComingFromMatrix.elements.get(0).toResponse()
      );
      response.put(
        OUTPUT_COMMERCIAL_ATTRIBUTES_COMING_FROM_MATRIX,
        commercialAttributesComingFromMatrix.toResponse()
      );
    }

    response.put(
      OUTPUT_AUTO_APPLIED_PROMOTIONS,
      promotions.getAutoAppliedPromotionsGroupedByPositionResponse()
    );

    response.put(
      OUTPUT_AUTO_APPLIED_PROMOTIONS_AT_BROWSE_OFFER,
      promotions.getAutoAppliedPromotionsAtBrowseOffer().toResponse()
    );

    response.put(OUTPUT_PROMOTIONS, promotions.toResponse());
    response.put(OUTPUT_AMOUNT, prices.getPrice().amount());
    response.put(OUTPUT_INITIAL_AMOUNT, prices.getPrice().initialAmount());
    response.put(
      OUTPUT_HAS_RECURRING_CHARGE,
      prices.getPrice().isRecurringCharge()
    );
    response.put(OUTPUT_OFFER_VARIANT_CODE, offerVariantCode());
    return response;
  }
  public VNOS_DOMAIN_Product duplicate() {
    return new VNOS_DOMAIN_Product(
      (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(node))
    );
  }
}