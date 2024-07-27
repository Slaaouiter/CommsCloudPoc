public class VNOS_DOMAIN_Products {
  @TestVisible
  private static final String OUTPUT_PRODUCTS = 'products';
  @TestVisible
  private static final String OUTPUT_ORDER = 'order';
  @TestVisible
  private static final String OUTPUT_PRODUCT = 'product';
  @TestVisible
  private static final String OUTPUT_IS_GROUPED = 'isGrouped';

  public List<VNOS_DOMAIN_Product> elements = new List<VNOS_DOMAIN_Product>();

  public VNOS_DOMAIN_Products() {
  }
  public VNOS_DOMAIN_Products(List<VNOS_DOMAIN_Offer> offers) {
    for (VNOS_DOMAIN_Offer offer : offers) {
      if (offer instanceof VNOS_DOMAIN_Product) {
        elements.add((VNOS_DOMAIN_Product) offer);
      }
    }
  }
  public VNOS_DOMAIN_Products(List<Object> products) {
    if (products != null && !products.isEmpty()) {
      for (Object product : products) {
        elements.add(new VNOS_DOMAIN_Product((Map<String, Object>) product));
      }
    }
  }

  public Set<String> attributePricingMatrixNames(String defaultAttributePricingMatrixName){
    Set<String> names = new Set<String>();
    for(VNOS_DOMAIN_Product product : elements){
      VNOS_DOMAIN_CommercialAttribute pricingMatrixAttribute =  product.attributes.getPricingMatrixAttribute();
      if(pricingMatrixAttribute != null && String.isNotBlank(pricingMatrixAttribute.value())){
        names.add(pricingMatrixAttribute.value());
      }else if(String.isNotBlank(defaultAttributePricingMatrixName) && !names.contains(defaultAttributePricingMatrixName)){
        names.add(defaultAttributePricingMatrixName);
      }
    }
    return names;
  }
  
  @TestVisible
  private Map<Integer, List<VNOS_DOMAIN_Product>> groupByOrderOfGroup() {
    Map<Integer, List<VNOS_DOMAIN_Product>> productsGroupedByOrderOfGroup = new Map<Integer, List<VNOS_DOMAIN_Product>>();
    for (VNOS_DOMAIN_Product product : elements) {
      if (productsGroupedByOrderOfGroup.containsKey(product.orderOfGroup())) {
        productsGroupedByOrderOfGroup.get(product.orderOfGroup()).add(product);
      } else {
        productsGroupedByOrderOfGroup.put(
          product.orderOfGroup(),
          new List<VNOS_DOMAIN_Product>{ product }
        );
      }
    }
    return productsGroupedByOrderOfGroup;
  }

  public void autoApplyPromotionsAtBrowseOffer() {
    for (VNOS_DOMAIN_Product product : elements) {
      product.autoApplyPromotionsAtBrowseOffer();
    }
  }

  public List<Object> toResponse() {
    List<Object> responseList = new List<Object>();

    Map<Integer, List<VNOS_DOMAIN_Product>> productsGroupedByOrderOfGroup = groupByOrderOfGroup();

    List<Integer> orderOfGroups = new List<Integer>(
      productsGroupedByOrderOfGroup.keySet()
    );
    orderOfGroups.sort();

    for (Integer orderOfGroup : orderOfGroups) {
      List<VNOS_DOMAIN_Product> groupedProducts = productsGroupedByOrderOfGroup.get(
        orderOfGroup
      );
      Map<String, Object> response = new Map<String, Object>();
      response.put(OUTPUT_ORDER, orderOfGroup);

      if (groupedProducts.size() == 1) {
        VNOS_DOMAIN_Product product = groupedProducts.get(0);
        response.put(OUTPUT_IS_GROUPED, false);
        response.put(OUTPUT_PRODUCT, product.toResponse());
      } else {
        groupedProducts.sort();
        response.put(OUTPUT_IS_GROUPED, true);
        response.put(OUTPUT_PRODUCTS, toResponse(groupedProducts));
      }
      responseList.add(response);
    }
    return responseList;
  }

  private List<Object> toResponse(List<VNOS_DOMAIN_Product> products) {
    List<Object> response = new List<Object>();
    for (VNOS_DOMAIN_Product product : products) {
      response.add(product.toResponse());
    }
    return response;
  }
}