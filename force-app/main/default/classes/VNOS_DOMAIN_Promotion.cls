public class VNOS_DOMAIN_Promotion extends VNOS_DOMAIN_Offer {
  @TestVisible
  private static final String CONST_SEMI_COLON_SEPARATOR = ';';
  @TestVisible
  private static final String CONST_LOYALTY_DEPENDENT = 'LoyaltyDependent';
  @TestVisible
  private static final String CONST_LOYALTY_EXCLUDED = 'LoyaltyExcluded';
  @TestVisible
  private static final String CONST_PRODUCT = 'Product';
  @TestVisible
  private static final String CONST_NAME = 'Name';
  @TestVisible
  private static final String CONST_VLOCITY_CMT_CODE_C = 'vlocity_cmt__Code__c';
  @TestVisible
  private static final String CONST_VLOCITY_CMT_DESCRIPTION_C = 'vlocity_cmt__Description__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C = 'VNOS_PROM_SEL_AutoApplyMoment__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C = 'VNOS_PROM_SEL_BrowseHighlighting__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_FLG_IS_LOYALTY_C = 'VNOS_PROM_FLG_IsLoyalty__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_SEL_PROCESS_TAGS_C = 'VNOS_PROM_SEL_ProcessTags__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C = 'VNOS_PROM_TXT_BaseOfferVariants__c';

  @TestVisible
  private static final String CONST_VNOS_PROM_FLG_KEEP_TARIFF_C = 'VNOS_PROM_FLG_KeepOnTariffChange__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_ID_C = 'VNOS_PROM_FOR_Id__c';
  @TestVisible
  private static final String CONST_RECORD_TYPE = 'RecordType';
  @TestVisible
  private static final String CONST_CHARGE_AMOUNT = 'chargeAmount';
  @TestVisible
  private static final String CONST_AT_OFFER_BROWSE = 'At Offer Browse';
  @TestVisible
  private static final String CONST_VNOS_PROM_TXT_PUBLIC_LONG_DESC_C = 'VNOS_PROM_TXT_PublicLongDesc__c';
  @TestVisible
  private static final String CONST_VNOS_PROM_TXTL_PUBLIC_SHORT_DESC_C = 'VNOS_PROM_TXT_PublicShortDesc__c';

  @TestVisible
  private static final String OUTPUT_CHARGE_AMOUNT_TEXT = 'chargeAmountText';
  @TestVisible
  private static final String OUTPUT_POSITION = 'position';
  @TestVisible
  private static final String OUTPUT_AUTO_APPLIED_MOMENT = 'autoAppliedMoment';
  @TestVisible
  private static final String OUTPUT_CODE = 'code';
  @TestVisible
  private static final String OUTPUT_DESCRIPTION = 'description';
  @TestVisible
  private static final String OUTPUT_NAME = 'name';
  @TestVisible
  private static final String OUTPUT_TYPE = 'type';
  @TestVisible
  private static final String OUTPUT_HAS_RECURRING_CHARGE = 'hasRecurringCharge';
  @TestVisible
  private static final String OUTPUT_IS_LOYALTY = 'isLoyalty';
  @TestVisible
  private static final String OUTPUT_IS_LOYALTY_DEPENDENT = 'isLoyaltyDependent';
  @TestVisible
  private static final String OUTPUT_IS_LOYALTY_EXCLUDED = 'isLoyaltyExcluded';
  @TestVisible
  private static final String OUTPUT_PUBLIC_LONG_DESC = 'publicLongDescription';
  @TestVisible
  private static final String OUTPUT_PUBLIC_SHORT_DESC = 'publicShortDescription';
  @TestVisible
  private static final String OUTPUT_IS_KEEP_TARIFF = 'isKeepTariff';
  @TestVisible
  private static final String OUTPUT_PROMO_ID = 'promoId';
  public Map<String, Object> node = new Map<String, Object>();
  public VNOS_DOMAIN_RecordType recordType = new VNOS_DOMAIN_RecordType();
  public VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
  public VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();

  public VNOS_DOMAIN_Promotion() {
  }

  public VNOS_DOMAIN_Promotion(Map<String, Object> promotion) {
    if (promotion != null) {
      this.node = promotion;
      this.recordType = new VNOS_DOMAIN_RecordType(
        promotion.get(CONST_RECORD_TYPE)
      );
      this.products = new VNOS_DOMAIN_Products(
        (List<Object>) promotion.get(CONST_PRODUCT)
      );
      this.price.chargeAmount(
        String.valueOf(promotion.get(CONST_CHARGE_AMOUNT))
      );
    }
  }

  public String name() {
    return String.valueOf(node.get(CONST_NAME));
  }

  public String code() {
    return String.valueOf(node.get(CONST_VLOCITY_CMT_CODE_C));
  }

  public String description() {
    return String.valueOf(node.get(CONST_VLOCITY_CMT_DESCRIPTION_C));
  }

  public String autoAppliedMoment() {
    return String.valueOf(node.get(CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C));
  }

  public String browseHighlightingPosition() {
    return String.valueOf(node.get(CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C));
  }

  public Boolean isLoyalty() {
    try {
      String isLoyalty = String.valueOf(
        node.get(CONST_VNOS_PROM_FLG_IS_LOYALTY_C)
      );
      return Boolean.valueOf(isLoyalty);
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      return false;
    }
  }

  public Boolean keepTarrif() {
    try {
      String keepTariff = String.valueOf(
        node.get(CONST_VNOS_PROM_FLG_KEEP_TARIFF_C)
      );
      return Boolean.valueOf(keepTariff);
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      return false;
    }
  }

  public String getId() {
    return String.valueOf(node.get(CONST_VNOS_PROM_ID_C));
  }

  public String processTags() {
    return String.valueOf(node.get(CONST_VNOS_PROM_SEL_PROCESS_TAGS_C));
  }

  public String baseOfferVariants() {
    return String.valueOf(node.get(CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C));
  }

  public Boolean isLoyaltyDependent() {
    try {
      String processTags = processTags();
      if (
        processTags != null &&
        processTags.indexOf(CONST_SEMI_COLON_SEPARATOR) != -1 // It is better than string.contains performance wise
      ) {
        String[] tags = processTags.split(CONST_SEMI_COLON_SEPARATOR);
        return tags.contains(CONST_LOYALTY_DEPENDENT);
      }
      return CONST_LOYALTY_DEPENDENT.equals(processTags);
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      return false;
    }
  }

  public Boolean isLoyaltyExcluded() {
    try {
      String processTags = processTags();
      if (
        processTags != null &&
        processTags.indexOf(CONST_SEMI_COLON_SEPARATOR) != -1 // It is better than string.contains performance wise
      ) {
        String[] tags = processTags.split(CONST_SEMI_COLON_SEPARATOR);
        return tags.contains(CONST_LOYALTY_EXCLUDED);
      }
      return CONST_LOYALTY_EXCLUDED.equals(processTags);
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      return false;
    }
  }

  public void price(VNOS_DOMAIN_Price price) {
    if (price != null) {
      this.price = price.duplicate();
      node.put(CONST_CHARGE_AMOUNT, price.chargeAmount());
    }
  }

  public Boolean isAutoApplied() {
    return String.isNotBlank(autoAppliedMoment());
  }

  public Boolean isAutoAppliedAtOfferBrowse() {
    return isAutoApplied() && CONST_AT_OFFER_BROWSE.equals(autoAppliedMoment());
  }

  public String publicLongDesc() {
    return String.valueOf(node.get(CONST_VNOS_PROM_TXT_PUBLIC_LONG_DESC_C));
  }

  public String publicShortDesc() {
    return String.valueOf(node.get(CONST_VNOS_PROM_TXTL_PUBLIC_SHORT_DESC_C));
  }

  public void applyVAT() {
    for (VNOS_DOMAIN_Product product : products.elements) {
      product.applyVAT();
    }
  }

  public void addToMap(
    Map<String, VNOS_DOMAIN_Promotions> productCodeToPromotions,
    Map<String, String> productCodeToContextProductCode
  ) {
    for (VNOS_DOMAIN_Product product : products.elements) {
      String code = (productCodeToContextProductCode.isEmpty() ||
        productCodeToContextProductCode == null)
        ? product.code()
        : productCodeToContextProductCode.get(product.code()); //Some promotions will be applied to a child product such as NET_OFFERTA but still need to be mapped to the parent offer which is UZO_MOBILE. this map provides the link between the two.

      VNOS_DOMAIN_Promotion promotionCopy = duplicate();
      promotionCopy.price(product.prices.getPrice());

      if (productCodeToPromotions.containsKey(code)) {
        productCodeToPromotions.get(code).elements.add(promotionCopy);
      } else {
        VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
        promotions.elements.add(promotionCopy);
        productCodeToPromotions.put(code, promotions);
      }
    }
  }

  public Boolean applicableToOfferVariant(String offerVariantCode) {
    String variants = baseOfferVariants();
    return String.isBlank(variants)
      ? true
      : variants.split(CONST_SEMI_COLON_SEPARATOR).contains(offerVariantCode);
  }

  public VNOS_DOMAIN_Promotion duplicate() {
    return new VNOS_DOMAIN_Promotion(
      (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(node))
    );
  }
  public Map<String, Object> toResponse() {
    Map<String, Object> response = new Map<String, Object>();

    response.put(CONST_CHARGE_AMOUNT, price.chargeAmount());
    response.put(OUTPUT_HAS_RECURRING_CHARGE, price.isRecurringCharge());
    response.put(OUTPUT_POSITION, browseHighlightingPosition());
    response.put(OUTPUT_AUTO_APPLIED_MOMENT, autoAppliedMoment());
    response.put(OUTPUT_CODE, code());
    response.put(OUTPUT_DESCRIPTION, description());
    response.put(OUTPUT_NAME, name());
    response.put(OUTPUT_TYPE, recordType.developerName());
    response.put(OUTPUT_IS_LOYALTY, isLoyalty());
    response.put(OUTPUT_IS_LOYALTY_DEPENDENT, isLoyaltyDependent());
    response.put(OUTPUT_IS_LOYALTY_EXCLUDED, isLoyaltyExcluded());
    response.put(OUTPUT_PUBLIC_LONG_DESC, publicLongDesc());
    response.put(OUTPUT_PUBLIC_SHORT_DESC, publicShortDesc());
    response.put(OUTPUT_IS_KEEP_TARIFF, keepTarrif());
    response.put(OUTPUT_PROMO_ID, getId());
    return response;
  }
}