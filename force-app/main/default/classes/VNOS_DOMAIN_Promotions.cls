public class VNOS_DOMAIN_Promotions {
  private static final String BROWSE_HIGHLIGHTING_SEPARATOR = ';';

  public List<VNOS_DOMAIN_Promotion> elements = new List<VNOS_DOMAIN_Promotion>();

  public VNOS_DOMAIN_Promotions() {
  }

  public VNOS_DOMAIN_Promotions(List<VNOS_DOMAIN_Offer> offers) {
    for (VNOS_DOMAIN_Offer offer : offers) {
      if (offer instanceof VNOS_DOMAIN_Promotion) {
        VNOS_DOMAIN_Promotion promotion = (VNOS_DOMAIN_Promotion) offer;
        elements.add(promotion);
      }
    }
  }

  public VNOS_DOMAIN_Promotions(List<Object> promotions) {
    for (Object promotion : promotions) {
      elements.add(new VNOS_DOMAIN_Promotion((Map<String, Object>) promotion));
    }
  }

  public Map<String, VNOS_DOMAIN_Promotions> groupByProductCode() {
    return groupByProductCode(new Map<String, String>());
  }


  public Map<String, VNOS_DOMAIN_Promotions> groupByProductCode(
    Map<String, String> productCodeToContextProductCode
  ) {
    Map<String, VNOS_DOMAIN_Promotions> productCodeToPromotions = new Map<String, VNOS_DOMAIN_Promotions>();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      promotion.addToMap(
        productCodeToPromotions,
        productCodeToContextProductCode
      );
    }
    return productCodeToPromotions;
  }

  public Map<String, VNOS_DOMAIN_Promotions> groupByBrowseHighlightingPosition() {
    Map<String, VNOS_DOMAIN_Promotions> positionToPromotions = new Map<String, VNOS_DOMAIN_Promotions>();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      String browseHighlightingPosition = promotion.browseHighlightingPosition();
      if (String.isNotBlank(browseHighlightingPosition)) {
        List<String> positions = browseHighlightingPosition.split(
          BROWSE_HIGHLIGHTING_SEPARATOR
        );
        for (String position : positions) {
          String positionWhithoutWhiteSpaces = position.replaceAll('\\s+', '');
          if (positionToPromotions.containsKey(positionWhithoutWhiteSpaces)) {
            positionToPromotions.get(positionWhithoutWhiteSpaces)
              .elements.add(promotion);
          } else {
            VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
            promotions.elements.add(promotion);
            positionToPromotions.put(positionWhithoutWhiteSpaces, promotions);
          }
        }
      }
    }
    return positionToPromotions;
  }

  public VNOS_DOMAIN_Promotions filterByOfferVariant(String offerVariantCode) {
    VNOS_DOMAIN_Promotions result = new VNOS_DOMAIN_Promotions();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      if (promotion.applicableToOfferVariant(offerVariantCode)) {
        result.elements.add(promotion);
      }
    }
    return result;
  }

  public VNOS_DOMAIN_Promotions getAutoAppliedPromotions() {
    VNOS_DOMAIN_Promotions autoAppliedPromotions = new VNOS_DOMAIN_Promotions();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      if (promotion.isAutoApplied()) {
        autoAppliedPromotions.elements.add(promotion);
      }
    }
    return autoAppliedPromotions;
  }

  public VNOS_DOMAIN_Promotions getAutoAppliedPromotionsAtBrowseOffer() {
    VNOS_DOMAIN_Promotions autoAppliedPromotions = new VNOS_DOMAIN_Promotions();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      if (promotion.isAutoAppliedAtOfferBrowse()) {
        autoAppliedPromotions.elements.add(promotion);
      }
    }
    return autoAppliedPromotions;
  }
  public Set<String> ids() {
    Set<String> ids = new Set<String>();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      ids.add(promotion.getId());
    }
    return ids;
  }
  public List<Object> toResponse() {
    List<Object> response = new List<Object>();
    for (VNOS_DOMAIN_Promotion promotion : elements) {
      response.add(promotion.toResponse());
    }
    return response;
  }

  public Map<String, Object> getAutoAppliedPromotionsGroupedByPositionResponse() {
    Map<String, Object> response = new Map<String, Object>();

    Map<String, VNOS_DOMAIN_Promotions> autoAppliedPromotionsGroupedByPosition = getAutoAppliedPromotions()
      .groupByBrowseHighlightingPosition();

    for (String position : autoAppliedPromotionsGroupedByPosition.keySet()) {
      response.put(
        position,
        autoAppliedPromotionsGroupedByPosition.get(position).toResponse()
      );
    }
    return response;
  }
}
