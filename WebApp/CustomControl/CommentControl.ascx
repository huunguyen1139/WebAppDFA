<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CommentControl.ascx.cs" Inherits="WebApp.CustomControl.CommentControl" ValidateRequestMode="Disabled" %>
<%@ Register TagPrefix="cc" Namespace="WebApp.Controls" Assembly="WebApp" %>

<script>
    function PostComment(btn) {
        btn.click();
        __doPostback('<%# btnAddComment.ClientID %>', '');
    }
</script>
<!-- show Reply form when user click on Reply link -->
<script type="text/javascript">
     function showReplyForm(commentId) {
        var formId = "replyForm_" + commentId;
        var replyDiv = document.getElementById(formId);
        if (replyDiv) {
            replyDiv.style.display = "block";
        }
    }

    function hideReplyForm(commentId) {
        var formId = "replyForm_" + commentId;
        var replyDiv = document.getElementById(formId);
        if (replyDiv) {
            replyDiv.style.display = "none";
        }
    }

    function submitOnEnter(e, buttonId) {

        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            document.getElementById(buttonId).click();
        }
    }
 </script>
<!-- call sweet alert for delete comment button -->
<script>
        function bindDeleteCommentButtons() {
        document.querySelectorAll(".btn-delete-comment").forEach(function (btn) {
            btn.addEventListener("click", function (e) {
                const confirmed = btn.getAttribute("data-confirmed");

                if (!confirmed) {
                    e.preventDefault();

                    Swal.fire({
                        title: "Are you sure?",
                            text: "This comment will be permanently deleted.",
                            type: "warning",
                            showCancelButton: true,
                            confirmButtonColor: "#d33",
                            cancelButtonColor: "#3085d6",
                            confirmButtonText: "Yes, delete it!"
                        }).then((result) => {
                            if (result.value) {
                                btn.setAttribute("data-confirmed", "true");
                                btn.click();
                            }
                            else {
                                bindDeleteCommentButtons();
                            }
                        });
                } else {
                    btn.removeAttribute("data-confirmed");
                }
            }, { once: true }); // prevent duplicate binding
        });
    }

    // Run on initial load
    document.addEventListener("DOMContentLoaded", function () {
        bindDeleteCommentButtons();
    });

        // Re-run after every partial postback
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        bindDeleteCommentButtons();
    });
    </script>    
<asp:UpdatePanel ID="up1" runat="server">
    <ContentTemplate>
<div class="card">
    <div class="border-bottom rounded-top title-part-padding bg-body">
        <h4 id="H1" runat="server" class="card-title mb-0 text-dark">Comments</h4>
    </div>
    <div class="card-body">
        <div class="col">
            <asp:Repeater ID="rptComments" runat="server" OnItemDataBound="rptComments_ItemDataBound">
                <ItemTemplate>
                    <div class="d-flex mb-3">
                        <!-- Avatar -->
                        <img src='<%# "../hs/images/users/" + Eval("UserName").ToString().Split('-')[1].Trim() + ".jpg" %>'
                         onerror="this.onerror=null; this.src='../hs/images/users/user2.png';"
                         class="rounded-circle me-3"
                         width="50" height="50" />

                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <strong><%# Eval("UserName") %></strong>
                                    <span class="text-muted small"
                                        title='<%# Eval("CommentDate", "{0:dd/MM/yyyy HH:mm}") %>'> - <%# FormatRelativeDate(Convert.ToDateTime(Eval("CommentDate"))) %>
                                    </span>
                                </div>
                            </div>

                            <!-- Comment Text -->
                            <div class="mt-1">
                                <p class="mb-1"><%# FormatCommentText(Eval("CommentText").ToString()) %></p>
                            </div>

                            <!-- Reply Link -->
                            <div class="mt-1">
                                <a href="javascript:void(0);"
                                    onclick="showReplyForm('<%# Eval("CommentID") %>')"
                                    class="text-primary small">&#x21a9; Reply
                                </a>
                                <%-- Only show delete if current user is owner --%>
                                <asp:PlaceHolder ID="phDelete" runat="server"
                                    Visible='<%# Eval("UserName").ToString().Contains(CurrentUserID) %>'>
                                    <asp:LinkButton ID="lnkDeleteComment" runat="server"
                                        CommandArgument='<%# Eval("CommentID") %>'
                                        OnClick="lnkDeleteComment_Click"
                                        CssClass="text-danger small btn-delete-comment" >
                                        <%--OnClientClick="return confirm('Are you sure you want to delete this comment?');">--%>
                                         • Delete
                                    </asp:LinkButton>
                                </asp:PlaceHolder>
                            </div>

                            <!-- Hidden Reply Form -->
                            <div id='replyForm_<%# Eval("CommentID") %>' style="display: none;" class="mt-2">                                
                                <cc:MentionEditorNew ID="mentionBoxReply" runat="server" Placeholder="Write your reply..."></cc:MentionEditorNew>
                                <div class="d-flex gap-2 mt-2">
                                    <asp:Button ID="btnReply" runat="server" Text="Reply" CssClass="btn btn-sm btn-dark"
                                        CommandArgument='<%# Eval("CommentID") %>' OnClick="btnReply_Click" />

                                    <button type="button" class="btn btn-sm btn-danger"
                                        onclick="hideReplyForm('<%# Eval("CommentID") %>')">
                                        Cancel</button>
                                </div>
                            </div>

                            <!-- Reply List -->
                            <asp:Repeater ID="rptReplies" runat="server" DataSource='<%# GetReplies(Eval("CommentID")) %>'>
                                <ItemTemplate>
                                    <div class="d-flex mt-3 ms-5">
                                        <img src='<%# "../hs/images/users/" + Eval("UserName").ToString().Split('-')[1].Trim() + ".jpg" %>'
                                         onerror="this.onerror=null; this.src='../hs/images/users/user2.png';"
                                         class="rounded-circle me-3"
                                         width="40" height="40" />
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <strong><%# Eval("UserName") %></strong>
                                                    <span class="text-muted small"
                                                        title='<%# Eval("CommentDate", "{0:dd/MM/yyyy HH:mm}") %>'>- <%# FormatRelativeDate(Convert.ToDateTime(Eval("CommentDate"))) %>
                                                    </span>
                                                </div>                                                                   
                                            </div>
                                            <p class="mb-1 mt-1"><%# FormatCommentText(Eval("CommentText").ToString()) %></p>
                                           
                                            <%-- Only show delete if current user is owner --%>
                                            <asp:PlaceHolder ID="phDelete" runat="server"
                                                Visible='<%# Eval("UserName").ToString().Contains(CurrentUserID) %>'>
                                                <asp:LinkButton ID="lnkDeleteComment" runat="server"
                                                    CommandArgument='<%# Eval("CommentID") %>'
                                                    OnClick="lnkDeleteComment_Click"
                                                    CssClass="text-danger small btn-delete-comment" >
                                                    <%--OnClientClick="return confirm('Are you sure you want to delete this comment?');">--%>
                                                     • Delete
                                                </asp:LinkButton>
                                            </asp:PlaceHolder>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                </ItemTemplate>
            </asp:Repeater>

            <!-- Comment Box -->
            
            <%--<asp:TextBox ID="txtComment" runat="server" CssClass="form-control my-2 mention-box" placeholder="Write a comment..."></asp:TextBox>--%>
            <%--<cc:MentionEditor ID="mentionBox" runat="server" Placeholder="Write a comment..." />--%>
            <cc:MentionEditorNew ID="mentionBoxNew" runat="server" Placeholder="Write a comment..."></cc:MentionEditorNew>
            <asp:Button ID="btnAddComment" runat="server" CssClass="btn btn-primary mt-3" Text="Post Comment" OnClick="btnAddComment_Click" 
                />

        </div>
    </div>
</div>
           </ContentTemplate>
</asp:UpdatePanel>