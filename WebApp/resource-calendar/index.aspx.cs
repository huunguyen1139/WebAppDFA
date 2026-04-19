using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;
using System.Data;
using System.Globalization;

namespace WebApplication2.resource_calendar
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            

            if (!IsPostBack)
            {
                divMessage.Visible = false;
                DateTime now = DateTime.Now;
                txtFromDate.Text = new DateTime(now.Year, now.Month, now.Day).ToString("yyyy-MM-dd");
                //txtToDate.Text = new DateTime(now.Year, now.Month, now.Day).ToString("yyyy-MM-dd");
                LoadResourceList();

                if (Request["id"] != null)
                {
                    LoadResourceEvent(Request["id"].ToString());
                    
                }
                else LoadResourceEvent("1");
            }
        }

        private void LoadResourceEvent(string ResourceID)
        {
            try
            {
                DataTable dt = Session["tbResourceList"] as DataTable;
                DataTable dtFilter = dt.AsEnumerable().Where(x => x["RowIndex"].ToString().Equals(ResourceID)).AsDataView().ToTable();
                string ResourceName = dtFilter.Rows[0]["ResourceName"].ToString();

                divResourceName.InnerHtml = ResourceName;

                ddResource.SelectedValue = ResourceID;

                //GetEventsList and show on calendar
                string sql = "select (Title + ' - ' + SubmitByName) Title , format(FromTime, 'yyyy-MM-dd HH:mm:ss') FromTime, format(ToTime, 'yyyy-MM-dd HH:mm:ss') ToTime from FC_Event where ResourceID = @ResourceID and Status=1";
                DataTable events = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@ResourceID" }, new List<object>() {ResourceID });
                CreateChartScriptString(events);
            }
            catch { }
        }

        private void CreateChartScriptString(DataTable EventList)
        {
            try
            {
                string events_string = string.Empty;

                //{ title: 'Meeting', start: '2020-09-12T10:30:00', end: '2020-09-12T12:30:00'}
                for (int i=0; i< EventList.Rows.Count - 1; i++)
                {
                    DataRow r = EventList.Rows[i];
                    events_string = events_string + "{ title: '" + r["Title"].ToString() + "', start: '" + r["FromTime"].ToString() + "', end: '" + r["ToTime"].ToString() + "'},";
                }
                DataRow r_end = EventList.Rows[EventList.Rows.Count - 1];
                events_string = events_string + "{ title: '" + r_end["Title"].ToString() + "', start: '" + r_end["FromTime"].ToString() + "', end: '" + r_end["ToTime"].ToString() + "'}";

                string hh = string.Empty;

                hh += "<script>";

                hh += " document.addEventListener('DOMContentLoaded', function() {";

                hh += " var calendarEl = document.getElementById('calendar');";
                hh += " var calendar = new FullCalendar.Calendar(calendarEl, {";
                hh += " headerToolbar: {";
                hh += " left: 'prev,next today',";
                hh += " center: 'title',";
                hh += " right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth' },";

                hh += @" eventClick: function(info) { alert(' Event: ' + info.event.title + '.\n Start: ' + info.event.start + '.\n End: ' + info.event.end); },";

                hh += " editable: false,";
                hh += " dayMaxEvents: true,";
                hh += " initialDate: '" + DateTime.Now.ToString("yyyy-MM-dd") + "',";
                hh += " droppable: false,";


                hh += " events: [";

                hh += events_string;
                //{ title: 'Conference', start: '2020-09-11', end: '2020-09-13'},
                //{ title: 'Meeting', start: '2020-09-12T10:30:00', end: '2020-09-12T12:30:00'}
                hh += "]";

                hh += "});";
                hh += " calendar.render();";

                hh += "});";

                hh += " </script>";

                

                Page.ClientScript.RegisterStartupScript(this.GetType(), DateTime.Now.Ticks.ToString(), hh);

            }
            catch { }
        }
        private string GetIconForResource(int i)
        {
            string result = "";
            try
            {
                while (i > 4)
                {
                    i = i - 4;
                }

                switch (i)
                {
                    case 1: result = @"<i class=""fa fa-circle text-info me-2""></i>"; break;
                    case 2: result = @"<i class=""fa fa-circle text-success me-2""></i>"; break;
                    case 3: result = @"<i class=""fa fa-circle text-danger me-2""></i>"; break;
                    case 4: result = @"<i class=""fa fa-circle text-warning me-2""></i>"; break;

                }
            }
            catch { }
            return result;
        }

        private void LoadResourceList()
        {
            try
            {
                string sql = "select * from FC_Resources where Blocked = 0";
                string html = string.Empty;
                ddResource.Items.Clear();
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                Session["tbResourceList"] = dt;
                int i = 0;
                foreach (DataRow r in dt.Rows)
                {
                    i += 1;
                    ddResource.Items.Add(new ListItem(r["ResourceName"].ToString(), r["RowIndex"].ToString()));
                    html += @"<div class=""calendar-events mb-3"" data-class=""bg-info""> " + GetIconForResource(i) + @"<a href=""index?id=" + r["RowIndex"].ToString() + @"""> " + r["ResourceName"].ToString() + "</a></div>";
                }
                divResources.InnerHtml = html;
            }

            catch { }
        }

        protected void btnSAVE_Click(object sender, EventArgs e)
        {
            try
            {
                string sql = "INSERT INTO [FC_Event] ([Title],[FromTime],[ToTime],[GroupID],[ResourceID], [ResourceName],[SubmitBy], [SubmitByName],[SubmitDate],[Status]) ";
                sql += " values(@Title, @from, @to, @group, @resource, @resourcename, @userid, @username, getdate(), 1)";

                string from = txtFromDate.Text + " " + SQRLibrary.ConvertToInt(ddFromHours.Value).ToString("#00") + ":" + SQRLibrary.ConvertToInt(ddFromMinute.Value).ToString("0#");
                string to = txtFromDate.Text + " " + SQRLibrary.ConvertToInt(ddToHours.Value).ToString("#00") + ":" + SQRLibrary.ConvertToInt(ddToMinutes.Value).ToString("0#");

                DateTime fromtime; DateTime totime;
                DateTime.TryParseExact(from, "yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out fromtime);
                DateTime.TryParseExact(to, "yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out totime);

                if (txtTitle.Text.Length <=3)
                {
                    divMessage.Visible = true;
                    divMessage.InnerHtml = "Có lỗi xảy ra, bạn chưa nhập nội dung cuộc họp!";
                    divMessage.Attributes["class"] = "alert alert-danger mt-2";
                    return;
                }

                if (totime.Ticks < fromtime.Ticks)
                {
                    divMessage.Visible = true;
                    divMessage.InnerHtml = "Có lỗi xảy ra, thời gian kết thúc sự kiện nhỏ hơn thời gian bắt đầu!";
                    divMessage.Attributes["class"] = "alert alert-danger mt-2";
                    return;
                }

                string sql1 = "SELECT *  FROM [FC_Event] where ((FromTime < @from and ToTime > @from) or (FromTime < @to and ToTime > @to)";
                sql1 += " or (FromTime >= @from and ToTime <= @to)) and Status = 1 and ResourceID= @ResourceID";
                DataTable dt1 = SQRLibrary.ReturnDatatablefromSQL_mrp(sql1, new List<string>() {"@from", "@to", "@ResourceID" }, new List<object>() { from, to, ddResource.SelectedValue });

                if (dt1.Rows.Count > 0)
                {
                    divMessage.Visible = true;
                    divMessage.InnerHtml = "Có lỗi xảy ra, khoảng thời gian bạn chọn đã bị trùng lịch !";
                    divMessage.Attributes["class"] = "alert alert-danger mt-2";
                    return;
                }

                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@Title", "@from", "@to", "@group", "@resource", "@resourcename", "@userid", "@username" }
                , new List<object>() {txtTitle.Text, from, to, 0, ddResource.SelectedValue, ddResource.SelectedItem.Text, Session["userid"], Session["username"] });

                divMessage.Visible = true;
                divMessage.InnerHtml = "Đã cập nhật đăng ký sử dụng phòng họp thành công!";
                divMessage.Attributes["class"] = "alert alert-success mt-2";

                if (Request["id"] != null)
                {
                    LoadResourceEvent(Request["id"].ToString());
                }
                else LoadResourceEvent("1");
            }
            catch
            {
                divMessage.Visible = true;
                divMessage.InnerHtml = "Có lỗi xảy ra, vui lòng kiểm tra lại thông tin đã nhập!";
                divMessage.Attributes["class"] = "alert alert-danger mt-2";
            }
        }

        protected void btnMyEvent_Click(object sender, EventArgs e)
        {
            try
            {
                divResourceName.Visible = false;
                string sql = string.Empty;
                sql = "SELECT Title, format(FromTime, 'dd-MMM-yy HH:mm') FromTime, format(ToTime, 'dd-MMM-yy HH:mm') ToTime, ResourceName, SubmitByName, format(SubmitDate,'dd-MMM-yy HH:mm') SubmitDate, Status, RowIndex  FROM [FC_Event] where SubmitBy = @SubmitBy order by FromTime desc"; 

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@SubmitBy" }, new List<object>() { Session["userid"].ToString() });
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 1].Visible = true;
               
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 2].Visible = true;
                gvMyEvents.DataSource = dt;
                gvMyEvents.DataBind();
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 1].Visible = false;
                gvMyEvents.Visible = true;
            }
            catch { }
        }

        protected void lbtnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;

                GridViewRow r = lbtn.NamingContainer as GridViewRow;

                string RowIndex = r.Cells[gvMyEvents.Columns.Count - 1].Text;
                if (RowIndex == "") return;
                string sql = " update FC_Event set Status = 0 where RowIndex= @RowIndex";


                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@RowIndex" }, new List<object>() { SQRLibrary.ConvertToInt(RowIndex) });


                btnMyEvent_Click(sender, e);


                //ScriptManager.RegisterStartupScript(this, this.GetType(), "success", "ShowPopupSuccess('Successfully deleted...!')", true);
            }
            catch { }
        }

        protected void btnAllEvent_Click(object sender, EventArgs e)
        {
            try
            {
                divResourceName.Visible = false;
                string sql = string.Empty;
                sql = "SELECT Title, format(FromTime, 'dd-MMM-yy HH:mm') FromTime, format(ToTime, 'dd-MMM-yy HH:mm') ToTime, ResourceName, SubmitByName, format(SubmitDate,'dd-MMM-yy HH:mm') SubmitDate, Status, RowIndex  FROM [FC_Event] where Status=1 order by FromTime desc";

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@SubmitBy" }, new List<object>() { Session["userid"].ToString() });
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 1].Visible = true;
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 2].Visible = true;
                gvMyEvents.DataSource = dt;
                gvMyEvents.DataBind();
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 1].Visible = false;
                gvMyEvents.Columns[gvMyEvents.Columns.Count - 2].Visible = false;
                gvMyEvents.Visible = true;
            }
            catch { }
        }
    }
}