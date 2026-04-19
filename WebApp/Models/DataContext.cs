using SQRFunctionLibrary;
using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace PIMS.Model
{
    public partial class DataContext : DbContext
    {
        public DataContext()
            : base(SQRLibrary.erp_connection)
        {
        }

        public virtual DbSet<LIVE_ALLIANCE_90_Item> LIVE_ALLIANCE_90_Item { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Item_Unit_of_Measure> LIVE_ALLIANCE_90_Item_Unit_of_Measure { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Job> LIVE_ALLIANCE_90_Job { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Sales_Header> LIVE_ALLIANCE_90_Sales_Header { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Sales_Line> LIVE_ALLIANCE_90_Sales_Line { get; set; }
        public virtual DbSet<Custom_ItemInformation> Custom_ItemInformation { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Leg_Finish> LIVE_ALLIANCE_90_Leg_Finish { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Timber_Finish> LIVE_ALLIANCE_90_Timber_Finish { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Drawing_Code> LIVE_ALLIANCE_90_Drawing_Code { get; set; }
        public virtual DbSet<Custom_UploadFileHistory> Custom_UploadFileHistory { get; set; }
        public virtual DbSet<LIVE_ALLIANCE_90_Production_Order> LIVE_ALLIANCE_90_Production_Order { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.Unit_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.Cost_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.Length)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.Width)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.Height)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Production_Order>()
                .Property(e => e.SalePrice)
                .HasPrecision(38, 20);
            modelBuilder.Entity<LIVE_ALLIANCE_90_Drawing_Code>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Leg_Finish>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Timber_Finish>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Unit_Price)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Profit__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Unit_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Standard_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Last_Direct_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Indirect_Cost__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Lead_Time_Calculation)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Reorder_Point)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Maximum_Inventory)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Reorder_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Unit_List_Price)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Duty_Due__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Gross_Weight)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Net_Weight)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Units_per_Parcel)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Unit_Volume)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Duty_Unit_Conversion)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Budget_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Budgeted_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Budget_Profit)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Lot_Size)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rolled_up_Material_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rolled_up_Capacity_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Scrap__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Minimum_Order_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Maximum_Order_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Safety_Stock_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Order_Multiple)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Safety_Lead_Time)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rounding_Precision)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Time_Bucket)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rescheduling_Period)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Lot_Accumulation_Period)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Dampener_Period)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Dampener_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Overflow_Level)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Expiration_Calculation)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Length)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Width)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Height)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Single_Level_Material_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Single_Level_Capacity_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Single_Level_Subcontrd__Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Single_Level_Cap__Ovhd_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Single_Level_Mfg__Ovhd_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Overhead_Rate)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rolled_up_Subcontracted_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rolled_up_Mfg__Ovhd_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item>()
                .Property(e => e.Rolled_up_Cap__Overhead_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Qty__per_Unit_of_Measure)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Length)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Width)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Height)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Cubage)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Weight)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Item_Unit_of_Measure>()
                .Property(e => e.Cubage_2)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Job>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Payment_Discount__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Currency_Factor)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.VAT_Base_Discount__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Invoice_Discount_Value)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Prepayment__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Prepmt__Payment_Discount__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Shipping_Time)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Outbound_Whse__Handling_Time)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Total_CBM)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Deposit__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Header>()
                .Property(e => e.Deposit_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.timestamp)
                .IsFixedLength();

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Outstanding_Quantity)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__to_Invoice)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__to_Ship)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Unit_Price)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Unit_Cost__LCY_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.VAT__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Line_Discount__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Line_Discount_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Amount_Including_VAT)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Gross_Weight)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Net_Weight)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Units_per_Parcel)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Unit_Volume)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Outstanding_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__Shipped_Not_Invoiced)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Shipped_Not_Invoiced)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Quantity_Shipped)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Quantity_Invoiced)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Profit__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Inv__Discount_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Outstanding_Amount__LCY_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Shipped_Not_Invoiced__LCY_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.VAT_Base_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Unit_Cost)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Line_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.VAT_Difference)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Inv__Disc__Amount_to_Invoice)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepayment__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__Line_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__Amt__Inv_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__Amt__Incl__VAT)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepayment_Amount)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__VAT_Base_Amt_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepayment_VAT__)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt_Amt_to_Deduct)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt_Amt_Deducted)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__Amount_Inv__Incl__VAT)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__Amount_Inv___LCY_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt__VAT_Amount_Inv___LCY_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepayment_VAT_Difference)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt_VAT_Diff__to_Deduct)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Prepmt_VAT_Diff__Deducted)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__to_Assemble_to_Order)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__to_Asm__to_Order__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__per_Unit_of_Measure)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Quantity__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Outstanding_Qty___Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__to_Invoice__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__to_Ship__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__Shipped_Not_Invd___Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__Shipped__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Qty__Invoiced__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Shipping_Time)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Outbound_Whse__Handling_Time)
                .IsUnicode(false);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Qty__to_Receive)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Qty__to_Receive__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Qty__Rcd__Not_Invd_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Ret__Qty__Rcd__Not_Invd__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Rcd__Not_Invd_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Rcd__Not_Invd___LCY_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Qty__Received)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.Return_Qty__Received__Base_)
                .HasPrecision(38, 20);

            modelBuilder.Entity<LIVE_ALLIANCE_90_Sales_Line>()
                .Property(e => e.CNTNo)
                .HasPrecision(38, 20);
        }
    }
}
