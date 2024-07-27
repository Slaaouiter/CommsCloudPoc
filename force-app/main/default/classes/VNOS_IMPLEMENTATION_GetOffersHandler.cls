public class VNOS_IMPLEMENTATION_GetOffersHandler implements VNOS_INTERFACE_GetOffersHandler {
  private static final String CONST_OFFERS = 'offers';

  private VNOS_INTERFACE_PricingMatrixService pricingMatrixService = VNOS_IMPLEMENTATION_PricingMatrixService.getInstance();
  //private VNOS_INTERFACE_PromotionItemService promotionItemService = VNOS_IMPLEMENTATION_PromotionItemService.getInstance();
  
  private static VNOS_IMPLEMENTATION_GetOffersHandler instance;

  private VNOS_IMPLEMENTATION_GetOffersHandler() {}

  public static VNOS_IMPLEMENTATION_GetOffersHandler getInstance() {
    if (instance == null) {
      instance = new VNOS_IMPLEMENTATION_GetOffersHandler();
    }
    return instance;
  }

  public VNOS_DOMAIN_Offers constructOffersFromResponse(Map<String, Object> digitalCommerceApiResponse) {
    if (digitalCommerceApiResponse == null) {
      return new VNOS_DOMAIN_Offers();
    }
    List<Object> offersNodes = (List<Object>) digitalCommerceApiResponse.get(CONST_OFFERS);
    return new VNOS_DOMAIN_Offers(offersNodes);
  }

  public VNOS_DOMAIN_Products putPromotionsInsideProducts(VNOS_DOMAIN_Promotions promotions,VNOS_DOMAIN_Products products) {
    System.debug('process start : putting promotions inside of products');

    Map<String, VNOS_DOMAIN_Promotions> productCodeToPromotions = promotions.groupByProductCode();
    System.debug('grouped map : '+productCodeToPromotions);

    for (VNOS_DOMAIN_Product product : products.elements) {
      if(productCodeToPromotions.containsKey(product.code())){
        VNOS_DOMAIN_Promotions promotionsRelatedToProduct = productCodeToPromotions.get(product.code());
        product.promotions(promotionsRelatedToProduct);
      }
    }

    System.debug('process ends : putting promotions inside of products');
    return products;
  }

  public void multiplyProductsByAttributePricingMatrixRows(
    VNOS_DOMAIN_Offers offers,
    String attributePricingMatrixName
  ) {
    VNOS_DOMAIN_Products products = offers.getProducts();
    if(products.elements.isEmpty()){
      System.debug('Warning : There is no product to multiply --> Abort');
      return;
    }

    VNOS_DOMAIN_AttributePricingMatrixRows matrix = pricingMatrixService.getAttributePricingMatrixRows(attributePricingMatrixName);
    if(matrix.rows.isEmpty()){
      System.debug('Warning : No matrix rows found related to the matrix name'+ attributePricingMatrixName +' --> Abort');
      return;
    }

    multiplyProductsByAttributePricingMatrixRows(offers, products, matrix);
  }

  @TestVisible
  private void multiplyProductsByAttributePricingMatrixRows(VNOS_DOMAIN_Offers offers,VNOS_DOMAIN_Products products, VNOS_DOMAIN_AttributePricingMatrixRows matrix){
    System.debug('Start : multiplying products using Matrix rows');
    for (VNOS_DOMAIN_Product product : products.elements) {
      Map<String, VNOS_DOMAIN_AttributePricingMatrixRows> productCodeToAttributePricingMatrixRows = matrix.groupByProductCode();
        String code = product.code();
        if (productCodeToAttributePricingMatrixRows.containsKey(code)) {
          VNOS_DOMAIN_AttributePricingMatrixRows usedMatrix = productCodeToAttributePricingMatrixRows.get(code);
          for (VNOS_DOMAIN_AttributePricingMatrixRow row : usedMatrix.rows) {
            VNOS_DOMAIN_Product clone = product.duplicate();
            clone.updateFromMatrixRow(row);
            offers.add(clone);
          }
          offers.remove(product);
        }
      
    }
    System.debug('End : multiplying products using Matrix rows');
  }
}