const getAttribute = (product, attributeCode) => {
  return product?.commercialAttributesComingFromMatrix?.find((attribute) => {
    return attribute.code === attributeCode
  })
}

const getOptionsSize = (products, attribute) => {
  let size = 0
  if (products && attribute) {
    let options = []
    products.forEach((product) => {
      let commercialAttribute = getAttribute(product, attribute.code)
      //TODO Technical debt => we should not filter by value Unica. It should be more generic
      if (!options.includes(commercialAttribute?.value) && commercialAttribute.value !=='Unica') {
        options.push(commercialAttribute.value)
      }
    })
    size = options.length
  }
  return size
}

const hasAttribute = (product, attributeCode, attributeValue) => {
  let attribute = getAttribute(product, attributeCode)
  return attribute ? attribute.value === attributeValue : false
}

const getProductsThatHaveTheAttribute = (products, attribute) => {
  return products?.filter((product) =>
    hasAttribute(product, attribute.code, attribute.value)
  )
}

const getInputAttributes = (attributes) => {
  return attributes?.filter((attribute) => {
    return attribute.isInput
  })
}

const findProductWithSameInputAttributesAsSelectedProduct = (
  selectedProduct,
  products,
  attributeToIgnore
) => {
  return products?.find((product) => {
    let inputAttributes = getInputAttributes(
      product.commercialAttributesComingFromMatrix
    )
    let filtredInputAttributes = inputAttributes.filter(
      (attribute) => attribute.code !== attributeToIgnore.code
    )
    return filtredInputAttributes.every((attribute) =>
      hasAttribute(selectedProduct, attribute.code, attribute.value)
    )
  })
}

const convertStringToNumber = (numberString) => {
  const num = parseFloat(numberString)
  return isNaN(num) ? 0 : num
}

const getPriceDifferenceBetweenProducts = (a, b) => {
  let difference =
    convertStringToNumber(a?.amount) - convertStringToNumber(b?.amount)
  return difference.toFixed(4)
}

const getPriceDifferenceTextBetweenProducts = (a, b) => {
  let difference = getPriceDifferenceBetweenProducts(a, b)
  return (difference > 0 ? "+" : "-") + "€" + Math.abs(difference)
}

const sortProductsByAmountDescending = (products) => {
  return products?.sort((a, b) => {
    return convertStringToNumber(a?.amount) === convertStringToNumber(b?.amount)
      ? 0
      : convertStringToNumber(b?.amount) > convertStringToNumber(a?.amount)
      ? 1
      : -1
  })
}

const getNdsSize = (numberOfElements) => {
  if (numberOfElements >= 5) {
    return "nds-size--3-of-12 "
  }
  let size = Math.ceil(12 / numberOfElements)
  return "nds-size--" + size + "-of-12 "
}

const findBestMatchProduct = (products, selectedProduct, attribute) => {
  let productWithSameInputAttributesAsSelectedProduct =
    findProductWithSameInputAttributesAsSelectedProduct(
      selectedProduct,
      products,
      attribute
    )
  return productWithSameInputAttributesAsSelectedProduct
    ? productWithSameInputAttributesAsSelectedProduct
    : products[0]
}

const isPriceDifferenceZero = (a, b) => {
  let difference =
    convertStringToNumber(a?.amount) - convertStringToNumber(b?.amount)
  return difference === 0
}
const isSelectedProduct = (a, b) => {
  return a?.orderInGroup === b?.orderInGroup
}

export {
  convertStringToNumber,
  getAttribute,
  getOptionsSize,
  getNdsSize,
  hasAttribute,
  getProductsThatHaveTheAttribute,
  getInputAttributes,
  findProductWithSameInputAttributesAsSelectedProduct,
  sortProductsByAmountDescending,
  getPriceDifferenceBetweenProducts,
  getPriceDifferenceTextBetweenProducts,
  findBestMatchProduct,
  isPriceDifferenceZero,
  isSelectedProduct,
}