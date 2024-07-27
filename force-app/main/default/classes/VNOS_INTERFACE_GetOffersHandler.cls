public interface VNOS_INTERFACE_GetOffersHandler {
  VNOS_DOMAIN_Offers constructOffersFromResponse(Map<String, Object> digitalCommerceApiResponse);
  VNOS_DOMAIN_Products putPromotionsInsideProducts(VNOS_DOMAIN_Promotions promotions,VNOS_DOMAIN_Products products);
  void multiplyProductsByAttributePricingMatrixRows(VNOS_DOMAIN_Offers offers,String attributePricingMatrixName);
}