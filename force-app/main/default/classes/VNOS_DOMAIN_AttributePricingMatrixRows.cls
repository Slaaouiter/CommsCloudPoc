public class VNOS_DOMAIN_AttributePricingMatrixRows {
  public List<VNOS_DOMAIN_AttributePricingMatrixRow> rows = new List<VNOS_DOMAIN_AttributePricingMatrixRow>();

  public VNOS_DOMAIN_AttributePricingMatrixRows() {
  }
  public VNOS_DOMAIN_AttributePricingMatrixRows(
    List<CalculationMatrixRow> calculationMatrixRows
  ) {
    if (calculationMatrixRows != null && !calculationMatrixRows.isEmpty()) {
      for (CalculationMatrixRow calculationMatrixRow : calculationMatrixRows) {
        rows.add(
          new VNOS_DOMAIN_AttributePricingMatrixRow(calculationMatrixRow)
        );
      }
    }
  }

  public Map<String, VNOS_DOMAIN_AttributePricingMatrixRows> groupByProductCode() {
    Map<String, VNOS_DOMAIN_AttributePricingMatrixRows> attributePricingMatrixRowsGroupedByProductCode = new Map<String, VNOS_DOMAIN_AttributePricingMatrixRows>();
    for (VNOS_DOMAIN_AttributePricingMatrixRow row : this.rows) {
      if (
        attributePricingMatrixRowsGroupedByProductCode.containsKey(
          row.sourceProductCode
        )
      ) {
        attributePricingMatrixRowsGroupedByProductCode.get(
            row.sourceProductCode
          )
          .rows.add(row);
      } else {
        VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
        attributePricingMatrixRows.rows.add(row);
        attributePricingMatrixRowsGroupedByProductCode.put(
          row.sourceProductCode,
          attributePricingMatrixRows
        );
      }
    }
    return attributePricingMatrixRowsGroupedByProductCode;
  }
  public void filterByChannel(String channel) {
    if (String.isNotBlank(channel)) {
      List<VNOS_DOMAIN_AttributePricingMatrixRow> filtredRows = new List<VNOS_DOMAIN_AttributePricingMatrixRow>();
      for (VNOS_DOMAIN_AttributePricingMatrixRow row : this.rows) {
        if (row.isEligibleForChannel(channel)) {
          filtredRows.add(row);
        }
      }
      this.rows = filtredRows;
    }
  }

  public void filterByOrderable() {
    List<VNOS_DOMAIN_AttributePricingMatrixRow> filtredRows = new List<VNOS_DOMAIN_AttributePricingMatrixRow>();
    for (VNOS_DOMAIN_AttributePricingMatrixRow row : this.rows) {
      if (row.isOrderable) {
        filtredRows.add(row);
      }
    }
    this.rows = filtredRows;
  }
  public void excludeByProductCode(String productCode) {
    if (String.isNotBlank(productCode)) {
      VNOS_DOMAIN_AttributePricingMatrixRows filteredRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
      for (VNOS_DOMAIN_AttributePricingMatrixRow row : rows) {
        if (!productCode.equals(row.sourceProductCode)) {
          filteredRows.rows.add(row);
        }
      }
      this.rows = filteredRows.rows;
    }
  }

  public List<Object> toResponse() {
    List<Object> response = new List<Object>();
    for (VNOS_DOMAIN_AttributePricingMatrixRow row : rows) {
      response.add(row.toResponse());
    }
    return response;
  }

  public Map<String, Object> toResponseGroupedByProductCode() {
    Map<String, Object> response = new Map<String, Object>();
    Map<String, VNOS_DOMAIN_AttributePricingMatrixRows> attributePricingMatrixRowsGroupedByProductCode = this.groupByProductCode();
    for (
      String productCode : attributePricingMatrixRowsGroupedByProductCode.keySet()
    ) {
      response.put(
        productCode,
        attributePricingMatrixRowsGroupedByProductCode.get(productCode)
          .toResponse()
      );
    }
    return response;
  }
}
