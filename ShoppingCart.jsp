<%@ page import="beans.Product" %>
<%@ page import="beans.ShoppingItem" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="prodbean" scope="session" class="beans.ProductBean"/>
<jsp:setProperty name="prodbean" property="connectionUrl" value="jdbc:odbc:ecommweb"/>
<%
  Hashtable shoppingCart = (Hashtable) session.getAttribute("shoppingCart");
  if (shoppingCart==null)
    shoppingCart = new Hashtable(10);

String action = request.getParameter("action");
  if (action!=null && action.equals("addItem")) {
    try {
      int productId = Integer.parseInt(request.getParameter("pcode"));
      Product prod = prodbean.getProductDetails(productId);
      if (prod!=null) {
        ShoppingItem item = new ShoppingItem();
        item.productcode = productId;
        item.quantity = 1;
        item.price = prod.price;
        item.name = prod.name;
        item.description = prod.description;

        shoppingCart.put(Integer.toString(productId), item);
        session.setAttribute("shoppingCart", shoppingCart);
      }
    }
    catch (Exception e) {
      out.println("Error adding the selected product to the shopping cart");
    }
}

  if (action!=null && action.equals("updateItem")) {
    try {
      int productId = Integer.parseInt(request.getParameter("pcode"));
      int quantity = Integer.parseInt(request.getParameter("quantity"));
      ShoppingItem item = (ShoppingItem) shoppingCart.get(Integer.toString(productId));
      if (item!=null) {
        item.quantity = quantity;
      }
    }
    catch (Exception e) {
      out.println("Error updating shopping cart");
    }
  }

  if (action!=null && action.equals("deleteItem")) {
    try {
      int productId = Integer.parseInt(request.getParameter("pcode"));
      shoppingCart.remove(Integer.toString(productId));
    }
    catch (Exception e) {
      out.println("Error deleting the selected item from the shopping cart");
    }
  }

%>
<HTML>
<HEAD>
<TITLE>E-Commerce Site</TITLE>
</HEAD>
<BODY bgcolor="#FFFFFF" text="#000000">
<TABLE cellpadding="6" border="0" width="750">
<TR>
  <TD COLSPAN=2><jsp:include page="header.jsp" flush="true"/></TD>
</TR>
<TR>
  <TD><jsp:include page="menu.jsp" flush="true"/></TD>
  <TD VALIGN="TOP">
<%
%>
    <TABLE>
    <TR>
      <TD><FONT FACE="Arial" SIZE="4"><B>Name</B></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="4"><B>Description</B></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="4"><B>Price</B></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="4"><B>Quantity</B></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="4"><B>Subtotal</B></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="4"><B>Update</B></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="4"><B>Delete</B></FONT></TD>
    </TR>
<%

    Enumeration enum = shoppingCart.elements();
    while (enum.hasMoreElements()) {
      ShoppingItem item = (ShoppingItem) enum.nextElement();
%>
    <TR>
      <TD><FONT FACE="Arial" SIZE="3"><%=item.name%></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="3"><%=item.description%></FONT></TD>
      <TD><FONT FACE="Arial" SIZE="3"><%=item.price%></FONT></TD>
      <FORM>
      <INPUT TYPE="HIDDEN" NAME="action" VALUE="updateItem">
      <INPUT TYPE="HIDDEN" NAME="pcode" VALUE="<%=item.productcode%>">
      <TD><INPUT TYPE="TEXT" Size="3" NAME="quantity" VALUE="<%=item.quantity%>"></TD>
      <TD><FONT FACE="Arial" SIZE="3"><%=item.quantity*item.price%></FONT></TD>
      <TD><INPUT TYPE="SUBMIT" VALUE="Update"></TD>
      </FORM>
      <FORM>
      <INPUT TYPE="HIDDEN" NAME="action" VALUE="deleteItem">
      <INPUT TYPE="HIDDEN" NAME="pcode" VALUE="<%=item.productcode%>">
      <TD><INPUT TYPE="SUBMIT" VALUE="Delete"></TD>
      </FORM>
    </TR>
<%
    }
%>
  
    </TABLE>
  </TD>
</TR>
<tr>
<td>
 <form action="<%=response.encodeURL("itemslist.jsp")%>" method="post">
  <input type="submit" value="Continue Shopping">
</form>
</td>
<td>
<form action="<%=response.encodeURL("checkout.jsp")%>" method="post">
  <input type="submit" value="Place Order">
</form>
</td>
</tr>
</TABLE>

</BODY>
</HTML>
