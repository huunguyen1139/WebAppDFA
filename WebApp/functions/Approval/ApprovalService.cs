using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using WebApp.Models.Enum;

namespace WebApp.functions.approval
{
    public class ApprovalService
    {
       private static DataTable Exec(string sql, List<string> p, List<object> v)
        => SQRLibrary.ReturnDatatablefromSQL_mrp(sql, p, v);    

       public static void SetInfoToApprovalControl(ApprovalFlowControl control, ApprovalEnum.ApprovalDocumentType approvalDocumentType, string ExternalRef,
            string Title, string ProjectID = "", string DocumentDescription = "")
        {
            control.DocTypeId = approvalDocumentType;
            control.ProjectId = ProjectID;
            control.Title = Title;
            control.ExternalRef = ExternalRef;
            control.DocumentDescription = DocumentDescription;

        }

        public static bool IsReleased(int docId)
        {
            var dt = Exec(@"
            SELECT TOP 1 d.*, sm.StatusName
            FROM dbo.APPROVAL_Documents d
            JOIN dbo.APPROVAL_DocumentStatusMap sm
              ON sm.DocTypeId=d.DocTypeId AND sm.StatusCode=d.StatusCode
            WHERE d.DocId=@Doc AND sm.StatusName in ('Approved','Released')", new List<string>() { "@Doc" }, new List<object>() { docId });
            return dt.Rows.Count > 0;
        }

        public static DataTable GetReleaseRecipients(int docId, string ProjectCode = "")
        => Exec("EXEC dbo.APPROVAL_GetReleaseRecipients @Doc, @ProjectCode", new List<string>() { "@Doc", "@ProjectCode" }, new List<object>() { docId, ProjectCode });

        public static (int DocId, bool AlreadySent) BuildInstance(int docTypeId, string externalRef, string projectId, string title, string createdBy)
        {
            var dt = Exec(
                "DECLARE @rc INT, @doc INT, @inst INT; " +
                "EXEC dbo.APPROVAL_BuildInstance " +
                "  @DocTypeId=@dt, @ExternalRef=@ex, @ProjectId=@pr, " +
                "  @Title=@ti, @CreatedBy=@by, " +
                "  @ResultCode=@rc OUTPUT, @DocId=@doc OUTPUT, @InstanceId=@inst OUTPUT; " +
                "SELECT @rc AS rc, @doc AS doc;",
                new List<string>() { "@dt", "@ex", "@pr", "@ti", "@by" },
                new List<object>() { docTypeId, externalRef, projectId, title, createdBy });

            int rc = (int)dt.Rows[0]["rc"];
            int doc = (int)dt.Rows[0]["doc"];
            return (doc, rc == 1);
        }


        //cancel handle
        public static bool CancelApproval(int docId, string userId)
        {
            try
            {
                DataTable dt = Exec("EXEC dbo.APPROVAL_CancelApproval @doc,@by",
                     new List<string>() { "@doc", "@by" }, new List<object>() { docId, userId });

                return dt.Rows[0][0].ToString() == "1";
            }
            catch { return false; }

        }


        //approval or reject handle
        public static DataTable Submit(int docId, string userId, char action, string comment)
            => Exec("EXEC APPROVAL_SubmitAction @Doc,@User,@Act,@Cmt",
                    new List<string>() { "@Doc", "@User", "@Act", "@Cmt" },
                    new List<object>() { docId, userId, action, comment });

        public static DataTable Pending(string userId)
            => Exec("EXEC APPROVAL_GetPending @User",
                   new List<string>() { "@User" }, new List<object>() { userId });

        public static DataTable GetInstanceSteps(int docId)
        => Exec("SELECT Seq,ApproverId,Status,Comment,ActionOn "
          + "FROM APPROVAL_InstanceSteps s "
          + "JOIN APPROVAL_Instances i ON i.InstanceId=s.InstanceId "
          + "WHERE i.DocId=@Doc ORDER BY Seq",
           new List<string>() { "@Doc" }, new List<object> { docId });

        public static DataTable GetInstanceStepsResolved(int docId)
        {
            return Exec(
                "SELECT InstanceId, Seq, ApproverId, ApproverName, StatusName, Comment, ActionOn " +
                "FROM dbo.VW_APPROVAL_InstanceSteps_Resolved " +
                "WHERE InstanceId IN (SELECT InstanceId FROM dbo.APPROVAL_Instances WHERE DocId=@doc) " +
                "ORDER BY InstanceId desc, Seq",
                new List<string>() { "@doc" }, new List<object>() { docId });
        }

        public static DataTable GetInstanceStepsResolved(string ExRef)
        {
            return Exec(
                "SELECT InstanceId, Seq, ApproverId, ApproverName, StatusName, Comment, ActionOn " +
                "FROM dbo.VW_APPROVAL_InstanceSteps_Resolved " +
                "WHERE InstanceId IN (SELECT InstanceId FROM dbo.APPROVAL_Instances WHERE DocId IN (" +
                "SELECT DocId FROM APPROVAL_Documents WHERE ExternalRef = @Ref)) " +
                "ORDER BY InstanceId desc, Seq",
                new List<string>() { "@Ref" }, new List<object>() { ExRef });
        }

        public static bool SaveTemplateOrder(int flowId, IEnumerable<(int StepId, int Seq)> order)
        {
            // TVP → SQL
            var tvp = new DataTable();
            tvp.Columns.Add("StepId", typeof(int));
            tvp.Columns.Add("Seq", typeof(int));
            foreach (var s in order) tvp.Rows.Add(s.StepId, s.Seq);

            return SQRLibrary.ReturnDatatablefromSQL(
              "EXEC APPROVAL_SaveTemplateOrder @Flow,@Steps",
              new List<string> { "@Flow", "@Steps" },
              new List<object> { flowId, tvp }           // SQRLibrary maps TVP automatically
            ).Rows.Count == 0;                         // SP returns 0 rows when OK
        }

        public static DataTable GetTemplateSteps(int docTypeId, string projectId, string createdBy)
        {
            return Exec(
                "EXEC dbo.APPROVAL_GetTemplateSteps @dt,@pr,@cb",
                new List<string>() { "@dt", "@pr", "@cb" },
                new List<object>() {
                                    docTypeId,
                                    string.IsNullOrEmpty(projectId) ? (object)DBNull.Value : projectId,
                                    createdBy
                });
        }
               
        public static int? FindDocId(int docTypeId, string externalRef)
        {
            var dt = Exec("SELECT DocId FROM APPROVAL_Documents " +
                          "WHERE DocTypeId=@dt AND ExternalRef=@er " +
                          "  AND StatusCode NOT IN " +
                          "    (SELECT StatusCode FROM APPROVAL_DocumentStatusMap " +
                          "     WHERE DocTypeId=@dt AND StatusName IN ('Cancelled', 'Rejected')) ORDER BY DocId desc",
                          new List<string>() { "@dt", "@er" }, new List<object>() { docTypeId, externalRef });
            return dt.Rows.Count == 0 ? (int?)null : (int)dt.Rows[0][0];
        }

        public static string NextApproverID(int docID)
        {
            var dt = Exec(@"SELECT TOP 1 s.ApproverId
                             FROM APPROVAL_InstanceSteps s
                             JOIN APPROVAL_Instances  i ON i.InstanceId=s.InstanceId
                            WHERE i.DocId=@DocId
                              AND s.Status='P'                            
                            ORDER BY s.Seq",
                          new List<string>() { "@DocId" }, new List<object>() { docID});
            return dt.Rows.Count == 0 ? "" : dt.Rows[0][0].ToString();
        }

        /// <summary>
        /// Return the "next up" approver(s) for a document: all users in the FIRST pending Seq.
        /// Empty list = not sent yet or already finished.
        /// </summary>
        public static List<(string ApproverId, string ApproverName, string Email)> GetNextApprover(int docId)
        {
            var dt = Exec(@"EXEC APPROVAL_GetNextApprover @DocID", new List<string>() { "@DocID" }, new List<object>() { docId });
            var list = new List<(string, string, string)>(dt.Rows.Count);

            foreach (DataRow r in dt.Rows)
            {
                list.Add((r["ApproverId"].ToString(), r["ApproverName"].ToString(), r["Email"].ToString()));
            }
            return list;
        }


        /// <summary>
        /// Return the document creator (sender). Null if the approval header doesn’t exist yet.
        /// </summary>
        public static (string SenderId, string SenderName, string Email) GetCreator(int docId)
        {
            var dt = Exec(@"
            SELECT d.CreatedBy AS SenderId, u.EmployeeName AS SenderName, u.Email
            FROM dbo.APPROVAL_Documents d
            JOIN dbo.Employee u ON u.EmployeeID = d.CreatedBy
            WHERE d.DocId = @Doc;"
                , new List<string>() { "@Doc" }
                , new List<object>() { docId });

            if (dt.Rows.Count == 0) return ("", "", "");
            var r = dt.Rows[0];
            return ((string)r["SenderId"], (string)r["SenderName"], (string)r["Email"]);
        }

        public static DataTable GetPendingResolved(string userId)
        {
            return Exec(@"EXEC APPROVAL_GetPending @u",
            new List<string>() { "@u" }, new List<object>() { userId });
        }

        public class UserInfo
        {
            public int Id { get; set; }
            public string Name { get; set; }
        }
    }
}