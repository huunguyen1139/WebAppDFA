namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Sales Header")]
    public partial class LIVE_ALLIANCE_90_Sales_Header
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [Column("Document Type", Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Document_Type { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(20)]
        public string No_ { get; set; }

        [Column("Sell-to Customer No_")]
        
        [StringLength(20)]
        public string Sell_to_Customer_No_ { get; set; }

        [Column("Bill-to Customer No_")]
        
        [StringLength(20)]
        public string Bill_to_Customer_No_ { get; set; }

        [Column("Bill-to Name")]
        
        [StringLength(100)]
        public string Bill_to_Name { get; set; }

        [Column("Bill-to Name 2")]
        
        [StringLength(100)]
        public string Bill_to_Name_2 { get; set; }

        [Column("Bill-to Address")]
        
        [StringLength(100)]
        public string Bill_to_Address { get; set; }

        [Column("Bill-to Address 2")]
        
        [StringLength(100)]
        public string Bill_to_Address_2 { get; set; }

        [Column("Bill-to City")]
        
        [StringLength(30)]
        public string Bill_to_City { get; set; }

        [Column("Bill-to Contact")]
        
        [StringLength(90)]
        public string Bill_to_Contact { get; set; }

        [Column("Your Reference")]
        
        [StringLength(150)]
        public string Your_Reference { get; set; }

        [Column("Ship-to Code")]
        
        [StringLength(10)]
        public string Ship_to_Code { get; set; }

        [Column("Ship-to Name")]
        
        [StringLength(100)]
        public string Ship_to_Name { get; set; }

        [Column("Ship-to Name 2")]
        
        [StringLength(100)]
        public string Ship_to_Name_2 { get; set; }

        [Column("Ship-to Address")]
        
        [StringLength(100)]
        public string Ship_to_Address { get; set; }

        [Column("Ship-to Address 2")]
        
        [StringLength(100)]
        public string Ship_to_Address_2 { get; set; }

        [Column("Ship-to City")]
        
        [StringLength(30)]
        public string Ship_to_City { get; set; }

        [Column("Ship-to Contact")]
        
        [StringLength(100)]
        public string Ship_to_Contact { get; set; }

        [Column("Order Date")]
        public DateTime Order_Date { get; set; }

        [Column("Posting Date")]
        public DateTime Posting_Date { get; set; }

        [Column("Shipment Date")]
        public DateTime Shipment_Date { get; set; }

        [Column("Posting Description")]
        
        [StringLength(100)]
        public string Posting_Description { get; set; }

        [Column("Payment Terms Code")]
        
        [StringLength(10)]
        public string Payment_Terms_Code { get; set; }

        [Column("Due Date")]
        public DateTime Due_Date { get; set; }

        [Column("Payment Discount _")]
        public decimal Payment_Discount__ { get; set; }

        [Column("Pmt_ Discount Date")]
        public DateTime Pmt__Discount_Date { get; set; }

        [Column("Shipment Method Code")]
        
        [StringLength(10)]
        public string Shipment_Method_Code { get; set; }

        [Column("Location Code")]
        
        [StringLength(10)]
        public string Location_Code { get; set; }

        [Column("Shortcut Dimension 1 Code")]
        
        [StringLength(20)]
        public string Shortcut_Dimension_1_Code { get; set; }

        [Column("Shortcut Dimension 2 Code")]
        
        [StringLength(20)]
        public string Shortcut_Dimension_2_Code { get; set; }

        [Column("Customer Posting Group")]
        
        [StringLength(10)]
        public string Customer_Posting_Group { get; set; }

        [Column("Currency Code")]
        
        [StringLength(10)]
        public string Currency_Code { get; set; }

        [Column("Currency Factor")]
        public decimal Currency_Factor { get; set; }

        [Column("Customer Price Group")]
        
        [StringLength(10)]
        public string Customer_Price_Group { get; set; }

        [Column("Prices Including VAT")]
        public byte Prices_Including_VAT { get; set; }

        [Column("Invoice Disc_ Code")]
        
        [StringLength(20)]
        public string Invoice_Disc__Code { get; set; }

        [Column("Customer Disc_ Group")]
        
        [StringLength(20)]
        public string Customer_Disc__Group { get; set; }

        [Column("Language Code")]
        
        [StringLength(10)]
        public string Language_Code { get; set; }

        [Column("Salesperson Code")]
        
        [StringLength(10)]
        public string Salesperson_Code { get; set; }

        [Column("Order Class")]
        
        [StringLength(20)]
        public string Order_Class { get; set; }

        [Column("No_ Printed")]
        public int No__Printed { get; set; }

        [Column("On Hold")]
        
        [StringLength(3)]
        public string On_Hold { get; set; }

        [Column("Applies-to Doc_ Type")]
        public int Applies_to_Doc__Type { get; set; }

        [Column("Applies-to Doc_ No_")]
        
        [StringLength(20)]
        public string Applies_to_Doc__No_ { get; set; }

        [Column("Bal_ Account No_")]
        
        [StringLength(20)]
        public string Bal__Account_No_ { get; set; }

        public byte Ship { get; set; }

        public byte Invoice { get; set; }

        [Column("Print Posted Documents")]
        public byte Print_Posted_Documents { get; set; }

        [Column("Shipping No_")]
        
        [StringLength(20)]
        public string Shipping_No_ { get; set; }

        [Column("Posting No_")]
        
        [StringLength(20)]
        public string Posting_No_ { get; set; }

        [Column("Last Shipping No_")]
        
        [StringLength(20)]
        public string Last_Shipping_No_ { get; set; }

        [Column("Last Posting No_")]
        
        [StringLength(20)]
        public string Last_Posting_No_ { get; set; }

        [Column("Prepayment No_")]
        
        [StringLength(20)]
        public string Prepayment_No_ { get; set; }

        [Column("Last Prepayment No_")]
        
        [StringLength(20)]
        public string Last_Prepayment_No_ { get; set; }

        [Column("Prepmt_ Cr_ Memo No_")]
        
        [StringLength(20)]
        public string Prepmt__Cr__Memo_No_ { get; set; }

        [Column("Last Prepmt_ Cr_ Memo No_")]
        
        [StringLength(20)]
        public string Last_Prepmt__Cr__Memo_No_ { get; set; }

        [Column("VAT Registration No_")]
        
        [StringLength(20)]
        public string VAT_Registration_No_ { get; set; }

        [Column("Combine Shipments")]
        public byte Combine_Shipments { get; set; }

        [Column("Reason Code")]
        
        [StringLength(10)]
        public string Reason_Code { get; set; }

        [Column("Gen_ Bus_ Posting Group")]
        
        [StringLength(10)]
        public string Gen__Bus__Posting_Group { get; set; }

        [Column("EU 3-Party Trade")]
        public byte EU_3_Party_Trade { get; set; }

        [Column("Transaction Type")]
        
        [StringLength(10)]
        public string Transaction_Type { get; set; }

        [Column("Transport Method")]
        
        [StringLength(10)]
        public string Transport_Method { get; set; }

        [Column("VAT Country_Region Code")]
        
        [StringLength(10)]
        public string VAT_Country_Region_Code { get; set; }

        [Column("Sell-to Customer Name")]
        
        [StringLength(100)]
        public string Sell_to_Customer_Name { get; set; }

        [Column("Sell-to Customer Name 2")]
        
        [StringLength(100)]
        public string Sell_to_Customer_Name_2 { get; set; }

        [Column("Sell-to Address")]
        
        [StringLength(100)]
        public string Sell_to_Address { get; set; }

        [Column("Sell-to Address 2")]
        
        [StringLength(100)]
        public string Sell_to_Address_2 { get; set; }

        [Column("Sell-to City")]
        
        [StringLength(30)]
        public string Sell_to_City { get; set; }

        [Column("Sell-to Contact")]
        
        [StringLength(100)]
        public string Sell_to_Contact { get; set; }

        [Column("Bill-to Post Code")]
        
        [StringLength(20)]
        public string Bill_to_Post_Code { get; set; }

        [Column("Bill-to County")]
        
        [StringLength(30)]
        public string Bill_to_County { get; set; }

        [Column("Bill-to Country_Region Code")]
        
        [StringLength(10)]
        public string Bill_to_Country_Region_Code { get; set; }

        [Column("Sell-to Post Code")]
        
        [StringLength(20)]
        public string Sell_to_Post_Code { get; set; }

        [Column("Sell-to County")]
        
        [StringLength(30)]
        public string Sell_to_County { get; set; }

        [Column("Sell-to Country_Region Code")]
        
        [StringLength(10)]
        public string Sell_to_Country_Region_Code { get; set; }

        [Column("Ship-to Post Code")]
        
        [StringLength(20)]
        public string Ship_to_Post_Code { get; set; }

        [Column("Ship-to County")]
        
        [StringLength(30)]
        public string Ship_to_County { get; set; }

        [Column("Ship-to Country_Region Code")]
        
        [StringLength(10)]
        public string Ship_to_Country_Region_Code { get; set; }

        [Column("Bal_ Account Type")]
        public int Bal__Account_Type { get; set; }

        [Column("Exit Point")]
        
        [StringLength(10)]
        public string Exit_Point { get; set; }

        public byte Correction { get; set; }

        [Column("Document Date")]
        public DateTime Document_Date { get; set; }

        [Column("External Document No_")]
        
        [StringLength(35)]
        public string External_Document_No_ { get; set; }

        
        [StringLength(10)]
        public string Area { get; set; }

        [Column("Transaction Specification")]
        
        [StringLength(10)]
        public string Transaction_Specification { get; set; }

        [Column("Payment Method Code")]
        
        [StringLength(10)]
        public string Payment_Method_Code { get; set; }

        [Column("Shipping Agent Code")]
        
        [StringLength(10)]
        public string Shipping_Agent_Code { get; set; }

        [Column("Package Tracking No_")]
        
        [StringLength(30)]
        public string Package_Tracking_No_ { get; set; }

        [Column("No_ Series")]
        
        [StringLength(10)]
        public string No__Series { get; set; }

        [Column("Posting No_ Series")]
        
        [StringLength(10)]
        public string Posting_No__Series { get; set; }

        [Column("Shipping No_ Series")]
        
        [StringLength(10)]
        public string Shipping_No__Series { get; set; }

        [Column("Tax Area Code")]
        
        [StringLength(20)]
        public string Tax_Area_Code { get; set; }

        [Column("Tax Liable")]
        public byte Tax_Liable { get; set; }

        [Column("VAT Bus_ Posting Group")]
        
        [StringLength(10)]
        public string VAT_Bus__Posting_Group { get; set; }

        public int Reserve { get; set; }

        [Column("Applies-to ID")]
        
        [StringLength(50)]
        public string Applies_to_ID { get; set; }

        [Column("VAT Base Discount _")]
        public decimal VAT_Base_Discount__ { get; set; }

        public int Status { get; set; }

        [Column("Invoice Discount Calculation")]
        public int Invoice_Discount_Calculation { get; set; }

        [Column("Invoice Discount Value")]
        public decimal Invoice_Discount_Value { get; set; }

        [Column("Send IC Document")]
        public byte Send_IC_Document { get; set; }

        [Column("IC Status")]
        public int IC_Status { get; set; }

        [Column("Sell-to IC Partner Code")]
        
        [StringLength(20)]
        public string Sell_to_IC_Partner_Code { get; set; }

        [Column("Bill-to IC Partner Code")]
        
        [StringLength(20)]
        public string Bill_to_IC_Partner_Code { get; set; }

        [Column("IC Direction")]
        public int IC_Direction { get; set; }

        [Column("Prepayment _")]
        public decimal Prepayment__ { get; set; }

        [Column("Prepayment No_ Series")]
        
        [StringLength(10)]
        public string Prepayment_No__Series { get; set; }

        [Column("Compress Prepayment")]
        public byte Compress_Prepayment { get; set; }

        [Column("Prepayment Due Date")]
        public DateTime Prepayment_Due_Date { get; set; }

        [Column("Prepmt_ Cr_ Memo No_ Series")]
        
        [StringLength(10)]
        public string Prepmt__Cr__Memo_No__Series { get; set; }

        [Column("Prepmt_ Posting Description")]
        
        [StringLength(50)]
        public string Prepmt__Posting_Description { get; set; }

        [Column("Prepmt_ Pmt_ Discount Date")]
        public DateTime Prepmt__Pmt__Discount_Date { get; set; }

        [Column("Prepmt_ Payment Terms Code")]
        
        [StringLength(10)]
        public string Prepmt__Payment_Terms_Code { get; set; }

        [Column("Prepmt_ Payment Discount _")]
        public decimal Prepmt__Payment_Discount__ { get; set; }

        [Column("Quote No_")]
        
        [StringLength(20)]
        public string Quote_No_ { get; set; }

        [Column("Job Queue Status")]
        public int Job_Queue_Status { get; set; }

        [Column("Job Queue Entry ID")]
        public Guid Job_Queue_Entry_ID { get; set; }

        [Column("Incoming Document Entry No_")]
        public int Incoming_Document_Entry_No_ { get; set; }

        [Column("Dimension Set ID")]
        public int Dimension_Set_ID { get; set; }

        [Column("Authorization Required")]
        public byte Authorization_Required { get; set; }

        [Column("Credit Card No_")]
        
        [StringLength(20)]
        public string Credit_Card_No_ { get; set; }

        [Column("Direct Debit Mandate ID")]
        
        [StringLength(35)]
        public string Direct_Debit_Mandate_ID { get; set; }

        [Column("Doc_ No_ Occurrence")]
        public int Doc__No__Occurrence { get; set; }

        [Column("Campaign No_")]
        
        [StringLength(20)]
        public string Campaign_No_ { get; set; }

        [Column("Sell-to Customer Template Code")]
        
        [StringLength(10)]
        public string Sell_to_Customer_Template_Code { get; set; }

        [Column("Sell-to Contact No_")]
        
        [StringLength(20)]
        public string Sell_to_Contact_No_ { get; set; }

        [Column("Bill-to Contact No_")]
        
        [StringLength(20)]
        public string Bill_to_Contact_No_ { get; set; }

        [Column("Bill-to Customer Template Code")]
        
        [StringLength(10)]
        public string Bill_to_Customer_Template_Code { get; set; }

        [Column("Opportunity No_")]
        
        [StringLength(20)]
        public string Opportunity_No_ { get; set; }

        [Column("Responsibility Center")]
        
        [StringLength(10)]
        public string Responsibility_Center { get; set; }

        [Column("Shipping Advice")]
        public int Shipping_Advice { get; set; }

        [Column("Posting from Whse_ Ref_")]
        public int Posting_from_Whse__Ref_ { get; set; }

        [Column("Requested Delivery Date")]
        public DateTime Requested_Delivery_Date { get; set; }

        [Column("Promised Delivery Date")]
        public DateTime Promised_Delivery_Date { get; set; }

        [Column("Shipping Time")]
        
        [StringLength(32)]
        public string Shipping_Time { get; set; }

        [Column("Outbound Whse_ Handling Time")]
        [StringLength(32)]
        public string Outbound_Whse__Handling_Time { get; set; }

        [Column("Shipping Agent Service Code")]
        
        [StringLength(10)]
        public string Shipping_Agent_Service_Code { get; set; }

        public byte Receive { get; set; }

        [Column("Return Receipt No_")]
        
        [StringLength(20)]
        public string Return_Receipt_No_ { get; set; }

        [Column("Return Receipt No_ Series")]
        
        [StringLength(10)]
        public string Return_Receipt_No__Series { get; set; }

        [Column("Last Return Receipt No_")]
        
        [StringLength(20)]
        public string Last_Return_Receipt_No_ { get; set; }

        [Column("Month Period")]
        
        [StringLength(30)]
        public string Month_Period { get; set; }

        
        [StringLength(30)]
        public string Container { get; set; }

        [Column("Total CBM")]
        public decimal Total_CBM { get; set; }

        [Column("Loading Date")]
        public DateTime Loading_Date { get; set; }

        [Column("Allow Line Disc_")]
        public byte Allow_Line_Disc_ { get; set; }

        [Column("Get Shipment Used")]
        public byte Get_Shipment_Used { get; set; }

        [Column("Assigned User ID")]
        
        [StringLength(50)]
        public string Assigned_User_ID { get; set; }

        [Column("Ma HD")]
        public int Ma_HD { get; set; }

        [Column("Ky hieu mau HD")]
        
        [StringLength(20)]
        public string Ky_hieu_mau_HD { get; set; }

        [Column("VAT Description")]
        
        [StringLength(100)]
        public string VAT_Description { get; set; }

        [Column("Description 2")]
        
        [StringLength(100)]
        public string Description_2 { get; set; }

        [Column("Description 3")]
        
        [StringLength(80)]
        public string Description_3 { get; set; }

        [Column("Deposit Mandatory")]
        public byte Deposit_Mandatory { get; set; }

        [Column("Deposit _")]
        public decimal Deposit__ { get; set; }

        [Column("Deposit Amount")]
        public decimal Deposit_Amount { get; set; }

        [Column("Deposit Doc No_")]
        
        [StringLength(20)]
        public string Deposit_Doc_No_ { get; set; }

        [Column("Deposit Posted")]
        public byte Deposit_Posted { get; set; }

        [Column("Deposit Account No_")]
        
        [StringLength(20)]
        public string Deposit_Account_No_ { get; set; }

        [Column("Deposit Date")]
        public DateTime Deposit_Date { get; set; }

        
        [StringLength(20)]
        public string MauHD { get; set; }

        public string JobNo { get; set; }

        public int AllocationFor { get; set; }

        
        [StringLength(50)]
        public string LastUpdatedUser { get; set; }

        public DateTime LastUpdatedDate { get; set; }
    }
}
