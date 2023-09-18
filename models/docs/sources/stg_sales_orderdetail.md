[comment]: < sales_orderdetail -

{% docs salesorderid %} Primary key for sales orders records. Foreign key to SalesOrderHeader.SalesOrderID. {% enddocs %}

{% docs salesorderdetailid %} Primary key. One incremental unique number per product sold. {% enddocs %}

{% docs carriertrackingnumber %} Shipment tracking number supplied by the shipper. {% enddocs %}

{% docs orderqty %} Quantity ordered per product. {% enddocs %}

{% docs productid %} Product sold to customer. Foreign key to Product.ProductID. {% enddocs %}

{% docs specialofferid %} Promotional code. Foreign key to SpecialOffer.SpecialOfferID. {% enddocs %}

{% docs unitprice %} Selling price of a single product. {% enddocs %}

{% docs unitpricediscount %} Single product discount amount. {% enddocs %}

{% docs linetotal %} Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty. {% enddocs %}

{% docs rowguid %} rowguidcol number uniquely identifying the record. Used to support a merge replication sample. {% enddocs %}

{% docs modifieddate %} Date and time the record was last updated. {% enddocs %}


