<%@ WebHandler Language="C#" CodeBehind="SearchHandle.ashx.cs" Class="LiveSearch.SearchHandle" %>

using System;
using System.Web;
using System.Xml;

public class SearchHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string query = context.Request.QueryString["q"];
        string response = "no suggestion";

        if (!string.IsNullOrEmpty(query)) {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(context.Server.MapPath("~/Links.xml"));

            XmlNodeList linkNodes = xmlDoc.GetElementsByTagName("link");
            string hint = "";

            foreach (XmlNode linkNode in linkNodes) {
                XmlNode titleNode = linkNode["title"];
                XmlNode urlNode = linkNode["url"];

                if (titleNode != null && urlNode != null) {
                    if (titleNode.InnerText.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0) {
                        if (string.IsNullOrEmpty(hint)) {
                            hint = $"<a href='{urlNode.InnerText}' target='_blank'>{titleNode.InnerText}</a>";
                        } else {
                            hint += $"<br /><a href='{urlNode.InnerText}' target='_blank'>{titleNode.InnerText}</a>";
                        }
                    }
                }
            }

            if (!string.IsNullOrEmpty(hint)) {
                response = hint;
            }
        }

        context.Response.ContentType = "text/html";
        context.Response.Write(response);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}