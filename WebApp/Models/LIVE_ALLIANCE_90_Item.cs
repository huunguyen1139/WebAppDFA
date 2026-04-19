namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Item")]
    public partial class LIVE_ALLIANCE_90_Item
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [StringLength(20)]
        public string No_ { get; set; }

        [Column("No_ 2")]        
        [StringLength(20)]
        public string No__2 { get; set; }

        
        [StringLength(50)]
        public string Description { get; set; }

        [Column("Search Description")]        
        [StringLength(50)]
        public string Search_Description { get; set; }
        [Column("Description 2")]
        
        [StringLength(50)]
        public string Description_2 { get; set; }

        [Column("Base Unit of Measure")]        
        [StringLength(10)]
        public string Base_Unit_of_Measure { get; set; }

        [Column("Price Unit Conversion")]
        public int Price_Unit_Conversion { get; set; }

        public int Type { get; set; }

        [Column("Inventory Posting Group")]
        
        [StringLength(10)]
        public string Inventory_Posting_Group { get; set; }

        [Column("Shelf No_")]
        
        [StringLength(10)]
        public string Shelf_No_ { get; set; }

        [Column("Item Disc_ Group")]
        
        [StringLength(20)]
        public string Item_Disc__Group { get; set; }

        [Column("Allow Invoice Disc_")]
        public byte Allow_Invoice_Disc_ { get; set; }

        [Column("Statistics Group")]
        public int Statistics_Group { get; set; }

        [Column("Commission Group")]
        public int Commission_Group { get; set; }

        [Column("Unit Price")]
        public decimal Unit_Price { get; set; }

        [Column("Price_Profit Calculation")]
        public int Price_Profit_Calculation { get; set; }

        [Column("Profit _")]
        public decimal Profit__ { get; set; }

        [Column("Costing Method")]
        public int Costing_Method { get; set; }

        [Column("Unit Cost")]
        public decimal Unit_Cost { get; set; }

        [Column("Standard Cost")]
        public decimal Standard_Cost { get; set; }

        [Column("Last Direct Cost")]
        public decimal Last_Direct_Cost { get; set; }

        [Column("Indirect Cost _")]
        public decimal Indirect_Cost__ { get; set; }

        [Column("Cost is Adjusted")]
        public byte Cost_is_Adjusted { get; set; }

        [Column("Allow Online Adjustment")]
        public byte Allow_Online_Adjustment { get; set; }

        [Column("Vendor No_")]
        
        [StringLength(20)]
        public string Vendor_No_ { get; set; }

        [Column("Vendor Item No_")]
        
        [StringLength(20)]
        public string Vendor_Item_No_ { get; set; }

        [Column("Lead Time Calculation")]
        
        [StringLength(32)]
        public string Lead_Time_Calculation { get; set; }

        [Column("Reorder Point")]
        public decimal Reorder_Point { get; set; }

        [Column("Maximum Inventory")]
        public decimal Maximum_Inventory { get; set; }

        [Column("Reorder Quantity")]
        public decimal Reorder_Quantity { get; set; }

        [Column("Alternative Item No_")]
        
        [StringLength(20)]
        public string Alternative_Item_No_ { get; set; }

        [Column("Unit List Price")]
        public decimal Unit_List_Price { get; set; }

        [Column("Duty Due _")]
        public decimal Duty_Due__ { get; set; }

        [Column("Duty Code")]
        
        [StringLength(10)]
        public string Duty_Code { get; set; }

        [Column("Gross Weight")]
        public decimal Gross_Weight { get; set; }

        [Column("Net Weight")]
        public decimal Net_Weight { get; set; }

        [Column("Units per Parcel")]
        public decimal Units_per_Parcel { get; set; }

        [Column("Unit Volume")]
        public decimal Unit_Volume { get; set; }

        
        [StringLength(10)]
        public string Durability { get; set; }

        [Column("Freight Type")]
        
        [StringLength(10)]
        public string Freight_Type { get; set; }

        [Column("Tariff No_")]
        
        [StringLength(20)]
        public string Tariff_No_ { get; set; }

        [Column("Duty Unit Conversion")]
        public decimal Duty_Unit_Conversion { get; set; }

        [Column("Country_Region Purchased Code")]
        
        [StringLength(10)]
        public string Country_Region_Purchased_Code { get; set; }

        [Column("Budget Quantity")]
        public decimal Budget_Quantity { get; set; }

        [Column("Budgeted Amount")]
        public decimal Budgeted_Amount { get; set; }

        [Column("Budget Profit")]
        public decimal Budget_Profit { get; set; }

        public byte Blocked { get; set; }

        [Column("Last Date Modified")]
        public DateTime Last_Date_Modified { get; set; }

        [Column("Price Includes VAT")]
        public byte Price_Includes_VAT { get; set; }

        [Column("VAT Bus_ Posting Gr_ (Price)")]
        
        [StringLength(10)]
        public string VAT_Bus__Posting_Gr___Price_ { get; set; }

        [Column("Gen_ Prod_ Posting Group")]
        
        [StringLength(10)]
        public string Gen__Prod__Posting_Group { get; set; }

        [Column(TypeName = "image")]
        public byte[] Picture { get; set; }

        [Column("Country_Region of Origin Code")]
        
        [StringLength(10)]
        public string Country_Region_of_Origin_Code { get; set; }

        [Column("Automatic Ext_ Texts")]
        public byte Automatic_Ext__Texts { get; set; }

        [Column("No_ Series")]
        
        [StringLength(10)]
        public string No__Series { get; set; }

        [Column("Tax Group Code")]
        
        [StringLength(10)]
        public string Tax_Group_Code { get; set; }

        [Column("VAT Prod_ Posting Group")]
        
        [StringLength(10)]
        public string VAT_Prod__Posting_Group { get; set; }

        public int Reserve { get; set; }

        [Column("Global Dimension 1 Code")]
        
        [StringLength(20)]
        public string Global_Dimension_1_Code { get; set; }

        [Column("Global Dimension 2 Code")]
        
        [StringLength(20)]
        public string Global_Dimension_2_Code { get; set; }

        [Column("Stockout Warning")]
        public int Stockout_Warning { get; set; }

        [Column("Prevent Negative Inventory")]
        public int Prevent_Negative_Inventory { get; set; }

        [Column("Application Wksh_ User ID")]
        
        [StringLength(128)]
        public string Application_Wksh__User_ID { get; set; }

        [Column("Assembly Policy")]
        public int Assembly_Policy { get; set; }

        
        [StringLength(14)]
        public string GTIN { get; set; }

        [Column("Default Deferral Template Code")]
        
        [StringLength(10)]
        public string Default_Deferral_Template_Code { get; set; }

        [Column("Low-Level Code")]
        public int Low_Level_Code { get; set; }

        [Column("Lot Size")]
        public decimal Lot_Size { get; set; }

        [Column("Serial Nos_")]
        
        [StringLength(10)]
        public string Serial_Nos_ { get; set; }

        [Column("Last Unit Cost Calc_ Date")]
        public DateTime Last_Unit_Cost_Calc__Date { get; set; }

        [Column("Rolled-up Material Cost")]
        public decimal Rolled_up_Material_Cost { get; set; }

        [Column("Rolled-up Capacity Cost")]
        public decimal Rolled_up_Capacity_Cost { get; set; }

        [Column("Scrap _")]
        public decimal Scrap__ { get; set; }

        [Column("Inventory Value Zero")]
        public byte Inventory_Value_Zero { get; set; }

        [Column("Discrete Order Quantity")]
        public int Discrete_Order_Quantity { get; set; }

        [Column("Minimum Order Quantity")]
        public decimal Minimum_Order_Quantity { get; set; }

        [Column("Maximum Order Quantity")]
        public decimal Maximum_Order_Quantity { get; set; }

        [Column("Safety Stock Quantity")]
        public decimal Safety_Stock_Quantity { get; set; }

        [Column("Order Multiple")]
        public decimal Order_Multiple { get; set; }

        [Column("Safety Lead Time")]
        
        [StringLength(32)]
        public string Safety_Lead_Time { get; set; }

        [Column("Flushing Method")]
        public int Flushing_Method { get; set; }

        [Column("Replenishment System")]
        public int Replenishment_System { get; set; }

        [Column("Rounding Precision")]
        public decimal Rounding_Precision { get; set; }

        [Column("Sales Unit of Measure")]
        
        [StringLength(10)]
        public string Sales_Unit_of_Measure { get; set; }

        [Column("Purch_ Unit of Measure")]
        
        [StringLength(10)]
        public string Purch__Unit_of_Measure { get; set; }

        [Column("Time Bucket")]
        
        [StringLength(32)]
        public string Time_Bucket { get; set; }

        [Column("Reordering Policy")]
        public int Reordering_Policy { get; set; }

        [Column("Include Inventory")]
        public byte Include_Inventory { get; set; }

        [Column("Manufacturing Policy")]
        public int Manufacturing_Policy { get; set; }

        [Column("Rescheduling Period")]
        
        [StringLength(32)]
        public string Rescheduling_Period { get; set; }

        [Column("Lot Accumulation Period")]
        
        [StringLength(32)]
        public string Lot_Accumulation_Period { get; set; }

        [Column("Dampener Period")]
        
        [StringLength(32)]
        public string Dampener_Period { get; set; }

        [Column("Dampener Quantity")]
        public decimal Dampener_Quantity { get; set; }

        [Column("Overflow Level")]
        public decimal Overflow_Level { get; set; }

        [Column("Manufacturer Code")]
        
        [StringLength(10)]
        public string Manufacturer_Code { get; set; }

        [Column("Item Category Code")]
        
        [StringLength(10)]
        public string Item_Category_Code { get; set; }

        [Column("Created From Nonstock Item")]
        public byte Created_From_Nonstock_Item { get; set; }

        [Column("Product Group Code")]
        
        [StringLength(10)]
        public string Product_Group_Code { get; set; }

        [Column("Service Item Group")]
        
        [StringLength(10)]
        public string Service_Item_Group { get; set; }

        [Column("Item Tracking Code")]
        
        [StringLength(10)]
        public string Item_Tracking_Code { get; set; }

        [Column("Lot Nos_")]
        
        [StringLength(10)]
        public string Lot_Nos_ { get; set; }

        [Column("Expiration Calculation")]
        
        [StringLength(32)]
        public string Expiration_Calculation { get; set; }

        [Column("Special Equipment Code")]
        
        [StringLength(10)]
        public string Special_Equipment_Code { get; set; }

        [Column("Put-away Template Code")]
        
        [StringLength(10)]
        public string Put_away_Template_Code { get; set; }

        [Column("Put-away Unit of Measure Code")]
        
        [StringLength(10)]
        public string Put_away_Unit_of_Measure_Code { get; set; }

        [Column("Phys Invt Counting Period Code")]
        
        [StringLength(10)]
        public string Phys_Invt_Counting_Period_Code { get; set; }

        [Column("Last Counting Period Update")]
        public DateTime Last_Counting_Period_Update { get; set; }

        [Column("Use Cross-Docking")]
        public byte Use_Cross_Docking { get; set; }

        [Column("Next Counting Start Date")]
        public DateTime Next_Counting_Start_Date { get; set; }

        [Column("Next Counting End Date")]
        public DateTime Next_Counting_End_Date { get; set; }

        [Column("VN Description")]
        
        [StringLength(150)]
        public string VN_Description { get; set; }

        [Column("Wood Finish")]
        
        [StringLength(50)]
        public string Wood_Finish { get; set; }

        [Column("Metal_Fab Finish")]
        
        [StringLength(50)]
        public string Metal_Fab_Finish { get; set; }

        [Column("Legs Finish")]
        
        [StringLength(20)]
        public string Legs_Finish { get; set; }

        [Column("Timber Finish")]
        
        [StringLength(20)]
        public string Timber_Finish { get; set; }

        [Column("Product Sub Group")]
        
        [StringLength(10)]
        public string Product_Sub_Group { get; set; }

        public decimal Length { get; set; }

        public decimal Width { get; set; }

        public decimal Height { get; set; }

        [Column("Full Description")]
        
        [StringLength(250)]
        public string Full_Description { get; set; }

        [Column("Full Search Description")]
        
        [StringLength(250)]
        public string Full_Search_Description { get; set; }

        
        [StringLength(10)]
        public string UOM2 { get; set; }

        [Column("Metal_Fab Code")]
        
        [StringLength(20)]
        public string Metal_Fab_Code { get; set; }

        [Column("Drawing Code")]
        
        [StringLength(20)]
        public string Drawing_Code { get; set; }

        [Column("Drawing Version Code")]
        
        [StringLength(20)]
        public string Drawing_Version_Code { get; set; }

        [Column("Spec_ Code")]
        
        [StringLength(20)]
        public string Spec__Code { get; set; }

        [Column("Spec_ Version Code")]
        
        [StringLength(20)]
        public string Spec__Version_Code { get; set; }

        [Column("Packing BOM")]
        
        [StringLength(20)]
        public string Packing_BOM { get; set; }

        [Column("Packing Code")]
        
        [StringLength(20)]
        public string Packing_Code { get; set; }

        [Column("Routing No_")]
        
        [StringLength(20)]
        public string Routing_No_ { get; set; }

        [Column("Production BOM No_")]
        
        [StringLength(20)]
        public string Production_BOM_No_ { get; set; }

        [Column("Single-Level Material Cost")]
        public decimal Single_Level_Material_Cost { get; set; }

        [Column("Single-Level Capacity Cost")]
        public decimal Single_Level_Capacity_Cost { get; set; }

        [Column("Single-Level Subcontrd_ Cost")]
        public decimal Single_Level_Subcontrd__Cost { get; set; }

        [Column("Single-Level Cap_ Ovhd Cost")]
        public decimal Single_Level_Cap__Ovhd_Cost { get; set; }

        [Column("Single-Level Mfg_ Ovhd Cost")]
        public decimal Single_Level_Mfg__Ovhd_Cost { get; set; }

        [Column("Overhead Rate")]
        public decimal Overhead_Rate { get; set; }

        [Column("Rolled-up Subcontracted Cost")]
        public decimal Rolled_up_Subcontracted_Cost { get; set; }

        [Column("Rolled-up Mfg_ Ovhd Cost")]
        public decimal Rolled_up_Mfg__Ovhd_Cost { get; set; }

        [Column("Rolled-up Cap_ Overhead Cost")]
        public decimal Rolled_up_Cap__Overhead_Cost { get; set; }

        [Column("Order Tracking Policy")]
        public int Order_Tracking_Policy { get; set; }

        public byte Critical { get; set; }

        [Column("Common Item No_")]        
        [StringLength(20)]
        public string Common_Item_No_ { get; set; }

        [Column("Packing Description")]
        [StringLength(150)]
        public string Packing_Description { get; set; }

        public int ItemType { get; set; }

        
        [Column("Finished Sample Code")]
        [StringLength(100)]
        public string Finished_Sample_Code { get; set; }
    }
}
