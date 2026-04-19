namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Sales Line")]
    public partial class LIVE_ALLIANCE_90_Sales_Line
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
        [Column("Document No_", Order = 1)]
        [StringLength(20)]
        public string Document_No_ { get; set; }

        [Key]
        [Column("Line No_", Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Line_No_ { get; set; }

        [Column("Sell-to Customer No_")]
        
        [StringLength(20)]
        public string Sell_to_Customer_No_ { get; set; }

        public int Type { get; set; }

        
        [StringLength(30)]
        public string No_ { get; set; }

        [Column("Location Code")]
        
        [StringLength(10)]
        public string Location_Code { get; set; }

        [Column("Posting Group")]
        
        [StringLength(10)]
        public string Posting_Group { get; set; }

        [Column("Shipment Date")]
        public DateTime Shipment_Date { get; set; }

        
        [StringLength(50)]
        public string Description { get; set; }

        [Column("Description 2")]
        
        [StringLength(50)]
        public string Description_2 { get; set; }

        [Column("Unit of Measure")]
        
        [StringLength(10)]
        public string Unit_of_Measure { get; set; }

        public decimal Quantity { get; set; }

        [Column("Outstanding Quantity")]
        public decimal Outstanding_Quantity { get; set; }

        [Column("Qty_ to Invoice")]
        public decimal Qty__to_Invoice { get; set; }

        [Column("Qty_ to Ship")]
        public decimal Qty__to_Ship { get; set; }

        [Column("Unit Price")]
        public decimal Unit_Price { get; set; }

        [Column("Unit Cost (LCY)")]
        public decimal Unit_Cost__LCY_ { get; set; }

        [Column("VAT _")]
        public decimal VAT__ { get; set; }

        [Column("Line Discount _")]
        public decimal Line_Discount__ { get; set; }

        [Column("Line Discount Amount")]
        public decimal Line_Discount_Amount { get; set; }

        public decimal Amount { get; set; }

        [Column("Amount Including VAT")]
        public decimal Amount_Including_VAT { get; set; }

        [Column("Allow Invoice Disc_")]
        public byte Allow_Invoice_Disc_ { get; set; }

        [Column("Gross Weight")]
        public decimal Gross_Weight { get; set; }

        [Column("Net Weight")]
        public decimal Net_Weight { get; set; }

        [Column("Units per Parcel")]
        public decimal Units_per_Parcel { get; set; }

        [Column("Unit Volume")]
        public decimal Unit_Volume { get; set; }

        [Column("Appl_-to Item Entry")]
        public int Appl__to_Item_Entry { get; set; }

        [Column("Shortcut Dimension 1 Code")]
        
        [StringLength(20)]
        public string Shortcut_Dimension_1_Code { get; set; }

        [Column("Shortcut Dimension 2 Code")]
        
        [StringLength(20)]
        public string Shortcut_Dimension_2_Code { get; set; }

        [Column("Customer Price Group")]
        
        [StringLength(10)]
        public string Customer_Price_Group { get; set; }

        [Column("Job No_")]
        
        [StringLength(20)]
        public string Job_No_ { get; set; }

        [Column("Work Type Code")]
        
        [StringLength(10)]
        public string Work_Type_Code { get; set; }

        [Column("Recalculate Invoice Disc_")]
        public byte Recalculate_Invoice_Disc_ { get; set; }

        [Column("Outstanding Amount")]
        public decimal Outstanding_Amount { get; set; }

        [Column("Qty_ Shipped Not Invoiced")]
        public decimal Qty__Shipped_Not_Invoiced { get; set; }

        [Column("Shipped Not Invoiced")]
        public decimal Shipped_Not_Invoiced { get; set; }

        [Column("Quantity Shipped")]
        public decimal Quantity_Shipped { get; set; }

        [Column("Quantity Invoiced")]
        public decimal Quantity_Invoiced { get; set; }

        [Column("Shipment No_")]
        
        [StringLength(20)]
        public string Shipment_No_ { get; set; }

        [Column("Shipment Line No_")]
        public int Shipment_Line_No_ { get; set; }

        [Column("Profit _")]
        public decimal Profit__ { get; set; }

        [Column("Bill-to Customer No_")]
        
        [StringLength(20)]
        public string Bill_to_Customer_No_ { get; set; }

        [Column("Inv_ Discount Amount")]
        public decimal Inv__Discount_Amount { get; set; }

        [Column("Purchase Order No_")]
        
        [StringLength(20)]
        public string Purchase_Order_No_ { get; set; }

        [Column("Purch_ Order Line No_")]
        public int Purch__Order_Line_No_ { get; set; }

        [Column("Drop Shipment")]
        public byte Drop_Shipment { get; set; }

        [Column("Gen_ Bus_ Posting Group")]
        
        [StringLength(10)]
        public string Gen__Bus__Posting_Group { get; set; }

        [Column("Gen_ Prod_ Posting Group")]
        
        [StringLength(10)]
        public string Gen__Prod__Posting_Group { get; set; }

        [Column("VAT Calculation Type")]
        public int VAT_Calculation_Type { get; set; }

        [Column("Transaction Type")]
        
        [StringLength(10)]
        public string Transaction_Type { get; set; }

        [Column("Transport Method")]
        
        [StringLength(10)]
        public string Transport_Method { get; set; }

        [Column("Attached to Line No_")]
        public int Attached_to_Line_No_ { get; set; }

        [Column("Exit Point")]
        
        [StringLength(10)]
        public string Exit_Point { get; set; }

        
        [StringLength(10)]
        public string Area { get; set; }

        [Column("Transaction Specification")]
        
        [StringLength(10)]
        public string Transaction_Specification { get; set; }

        [Column("Tax Category")]
        
        [StringLength(10)]
        public string Tax_Category { get; set; }

        [Column("Tax Area Code")]
        
        [StringLength(20)]
        public string Tax_Area_Code { get; set; }

        [Column("Tax Liable")]
        public byte Tax_Liable { get; set; }

        [Column("Tax Group Code")]
        
        [StringLength(10)]
        public string Tax_Group_Code { get; set; }

        [Column("VAT Clause Code")]
        
        [StringLength(10)]
        public string VAT_Clause_Code { get; set; }

        [Column("VAT Bus_ Posting Group")]
        
        [StringLength(10)]
        public string VAT_Bus__Posting_Group { get; set; }

        [Column("VAT Prod_ Posting Group")]
        
        [StringLength(10)]
        public string VAT_Prod__Posting_Group { get; set; }

        [Column("Currency Code")]
        
        [StringLength(10)]
        public string Currency_Code { get; set; }

        [Column("Outstanding Amount (LCY)")]
        public decimal Outstanding_Amount__LCY_ { get; set; }

        [Column("Shipped Not Invoiced (LCY)")]
        public decimal Shipped_Not_Invoiced__LCY_ { get; set; }

        public int Reserve { get; set; }

        [Column("Blanket Order No_")]
        
        [StringLength(20)]
        public string Blanket_Order_No_ { get; set; }

        [Column("Blanket Order Line No_")]
        public int Blanket_Order_Line_No_ { get; set; }

        [Column("VAT Base Amount")]
        public decimal VAT_Base_Amount { get; set; }

        [Column("Unit Cost")]
        public decimal Unit_Cost { get; set; }

        [Column("System-Created Entry")]
        public byte System_Created_Entry { get; set; }

        [Column("Line Amount")]
        public decimal Line_Amount { get; set; }

        [Column("VAT Difference")]
        public decimal VAT_Difference { get; set; }

        [Column("Inv_ Disc_ Amount to Invoice")]
        public decimal Inv__Disc__Amount_to_Invoice { get; set; }

        [Column("VAT Identifier")]
        
        [StringLength(10)]
        public string VAT_Identifier { get; set; }

        [Column("IC Partner Ref_ Type")]
        public int IC_Partner_Ref__Type { get; set; }

        [Column("IC Partner Reference")]
        
        [StringLength(20)]
        public string IC_Partner_Reference { get; set; }

        [Column("Prepayment _")]
        public decimal Prepayment__ { get; set; }

        [Column("Prepmt_ Line Amount")]
        public decimal Prepmt__Line_Amount { get; set; }

        [Column("Prepmt_ Amt_ Inv_")]
        public decimal Prepmt__Amt__Inv_ { get; set; }

        [Column("Prepmt_ Amt_ Incl_ VAT")]
        public decimal Prepmt__Amt__Incl__VAT { get; set; }

        [Column("Prepayment Amount")]
        public decimal Prepayment_Amount { get; set; }

        [Column("Prepmt_ VAT Base Amt_")]
        public decimal Prepmt__VAT_Base_Amt_ { get; set; }

        [Column("Prepayment VAT _")]
        public decimal Prepayment_VAT__ { get; set; }

        [Column("Prepmt_ VAT Calc_ Type")]
        public int Prepmt__VAT_Calc__Type { get; set; }

        [Column("Prepayment VAT Identifier")]
        
        [StringLength(10)]
        public string Prepayment_VAT_Identifier { get; set; }

        [Column("Prepayment Tax Area Code")]
        
        [StringLength(20)]
        public string Prepayment_Tax_Area_Code { get; set; }

        [Column("Prepayment Tax Liable")]
        public byte Prepayment_Tax_Liable { get; set; }

        [Column("Prepayment Tax Group Code")]
        
        [StringLength(10)]
        public string Prepayment_Tax_Group_Code { get; set; }

        [Column("Prepmt Amt to Deduct")]
        public decimal Prepmt_Amt_to_Deduct { get; set; }

        [Column("Prepmt Amt Deducted")]
        public decimal Prepmt_Amt_Deducted { get; set; }

        [Column("Prepayment Line")]
        public byte Prepayment_Line { get; set; }

        [Column("Prepmt_ Amount Inv_ Incl_ VAT")]
        public decimal Prepmt__Amount_Inv__Incl__VAT { get; set; }

        [Column("Prepmt_ Amount Inv_ (LCY)")]
        public decimal Prepmt__Amount_Inv___LCY_ { get; set; }

        [Column("IC Partner Code")]
        
        [StringLength(20)]
        public string IC_Partner_Code { get; set; }

        [Column("Prepmt_ VAT Amount Inv_ (LCY)")]
        public decimal Prepmt__VAT_Amount_Inv___LCY_ { get; set; }

        [Column("Prepayment VAT Difference")]
        public decimal Prepayment_VAT_Difference { get; set; }

        [Column("Prepmt VAT Diff_ to Deduct")]
        public decimal Prepmt_VAT_Diff__to_Deduct { get; set; }

        [Column("Prepmt VAT Diff_ Deducted")]
        public decimal Prepmt_VAT_Diff__Deducted { get; set; }

        [Column("Dimension Set ID")]
        public int Dimension_Set_ID { get; set; }

        [Column("Qty_ to Assemble to Order")]
        public decimal Qty__to_Assemble_to_Order { get; set; }

        [Column("Qty_ to Asm_ to Order (Base)")]
        public decimal Qty__to_Asm__to_Order__Base_ { get; set; }

        [Column("Job Task No_")]
        
        [StringLength(20)]
        public string Job_Task_No_ { get; set; }

        [Column("Job Contract Entry No_")]
        public int Job_Contract_Entry_No_ { get; set; }

        [Column("Deferral Code")]
        
        [StringLength(10)]
        public string Deferral_Code { get; set; }

        [Column("Returns Deferral Start Date")]
        public DateTime Returns_Deferral_Start_Date { get; set; }

        [Column("Variant Code")]
        
        [StringLength(10)]
        public string Variant_Code { get; set; }

        [Column("Bin Code")]
        
        [StringLength(20)]
        public string Bin_Code { get; set; }

        [Column("Qty_ per Unit of Measure")]
        public decimal Qty__per_Unit_of_Measure { get; set; }

        public byte Planned { get; set; }

        [Column("Unit of Measure Code")]
        
        [StringLength(10)]
        public string Unit_of_Measure_Code { get; set; }

        [Column("Quantity (Base)")]
        public decimal Quantity__Base_ { get; set; }

        [Column("Outstanding Qty_ (Base)")]
        public decimal Outstanding_Qty___Base_ { get; set; }

        [Column("Qty_ to Invoice (Base)")]
        public decimal Qty__to_Invoice__Base_ { get; set; }

        [Column("Qty_ to Ship (Base)")]
        public decimal Qty__to_Ship__Base_ { get; set; }

        [Column("Qty_ Shipped Not Invd_ (Base)")]
        public decimal Qty__Shipped_Not_Invd___Base_ { get; set; }

        [Column("Qty_ Shipped (Base)")]
        public decimal Qty__Shipped__Base_ { get; set; }

        [Column("Qty_ Invoiced (Base)")]
        public decimal Qty__Invoiced__Base_ { get; set; }

        [Column("FA Posting Date")]
        public DateTime FA_Posting_Date { get; set; }

        [Column("Depreciation Book Code")]
        
        [StringLength(10)]
        public string Depreciation_Book_Code { get; set; }

        [Column("Depr_ until FA Posting Date")]
        public byte Depr__until_FA_Posting_Date { get; set; }

        [Column("Duplicate in Depreciation Book")]
        
        [StringLength(10)]
        public string Duplicate_in_Depreciation_Book { get; set; }

        [Column("Use Duplication List")]
        public byte Use_Duplication_List { get; set; }

        [Column("Responsibility Center")]
        
        [StringLength(10)]
        public string Responsibility_Center { get; set; }

        [Column("Out-of-Stock Substitution")]
        public byte Out_of_Stock_Substitution { get; set; }

        [Column("Originally Ordered No_")]
        
        [StringLength(20)]
        public string Originally_Ordered_No_ { get; set; }

        [Column("Originally Ordered Var_ Code")]
        
        [StringLength(10)]
        public string Originally_Ordered_Var__Code { get; set; }

        [Column("Cross-Reference No_")]
        
        [StringLength(20)]
        public string Cross_Reference_No_ { get; set; }

        [Column("Unit of Measure (Cross Ref_)")]
        
        [StringLength(10)]
        public string Unit_of_Measure__Cross_Ref__ { get; set; }

        [Column("Cross-Reference Type")]
        public int Cross_Reference_Type { get; set; }

        [Column("Cross-Reference Type No_")]
        
        [StringLength(30)]
        public string Cross_Reference_Type_No_ { get; set; }

        [Column("Item Category Code")]
        
        [StringLength(10)]
        public string Item_Category_Code { get; set; }

        public byte Nonstock { get; set; }

        [Column("Purchasing Code")]
        
        [StringLength(10)]
        public string Purchasing_Code { get; set; }

        [Column("Product Group Code")]
        
        [StringLength(10)]
        public string Product_Group_Code { get; set; }

        [Column("Special Order")]
        public byte Special_Order { get; set; }

        [Column("Special Order Purchase No_")]
        
        [StringLength(20)]
        public string Special_Order_Purchase_No_ { get; set; }

        [Column("Special Order Purch_ Line No_")]
        public int Special_Order_Purch__Line_No_ { get; set; }

        [Column("Completely Shipped")]
        public byte Completely_Shipped { get; set; }

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

        [Column("Planned Delivery Date")]
        public DateTime Planned_Delivery_Date { get; set; }

        [Column("Planned Shipment Date")]
        public DateTime Planned_Shipment_Date { get; set; }

        [Column("Shipping Agent Code")]
        
        [StringLength(10)]
        public string Shipping_Agent_Code { get; set; }

        [Column("Shipping Agent Service Code")]
        
        [StringLength(10)]
        public string Shipping_Agent_Service_Code { get; set; }

        [Column("Allow Item Charge Assignment")]
        public byte Allow_Item_Charge_Assignment { get; set; }

        [Column("Return Qty_ to Receive")]
        public decimal Return_Qty__to_Receive { get; set; }

        [Column("Return Qty_ to Receive (Base)")]
        public decimal Return_Qty__to_Receive__Base_ { get; set; }

        [Column("Return Qty_ Rcd_ Not Invd_")]
        public decimal Return_Qty__Rcd__Not_Invd_ { get; set; }

        [Column("Ret_ Qty_ Rcd_ Not Invd_(Base)")]
        public decimal Ret__Qty__Rcd__Not_Invd__Base_ { get; set; }

        [Column("Return Rcd_ Not Invd_")]
        public decimal Return_Rcd__Not_Invd_ { get; set; }

        [Column("Return Rcd_ Not Invd_ (LCY)")]
        public decimal Return_Rcd__Not_Invd___LCY_ { get; set; }

        [Column("Return Qty_ Received")]
        public decimal Return_Qty__Received { get; set; }

        [Column("Return Qty_ Received (Base)")]
        public decimal Return_Qty__Received__Base_ { get; set; }

        [Column("Appl_-from Item Entry")]
        public int Appl__from_Item_Entry { get; set; }

        [Column("BOM Item No_")]
        
        [StringLength(20)]
        public string BOM_Item_No_ { get; set; }

        [Column("Return Receipt No_")]
        
        [StringLength(20)]
        public string Return_Receipt_No_ { get; set; }

        [Column("Return Receipt Line No_")]
        public int Return_Receipt_Line_No_ { get; set; }

        [Column("Return Reason Code")]
        
        [StringLength(10)]
        public string Return_Reason_Code { get; set; }

        [Column("Allow Line Disc_")]
        public byte Allow_Line_Disc_ { get; set; }

        [Column("Customer Disc_ Group")]
        
        [StringLength(20)]
        public string Customer_Disc__Group { get; set; }

        [Column("Packing Code")]
        
        [StringLength(10)]
        public string Packing_Code { get; set; }

        public decimal CNTNo { get; set; }

        
        [StringLength(20)]
        public string ApplyToOrderNo { get; set; }

        public int ApplyToLineNo { get; set; }
    }
}
