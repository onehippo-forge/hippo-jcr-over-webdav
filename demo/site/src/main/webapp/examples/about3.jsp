<%--
  Copyright 2008 Hippo

  Licensed under the Apache License, Version 2.0 (the  "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS"
  BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>

<%--
NOTE: This page is provided as an example to demonstrate how to use JCR API over WebDAV.
      This page simply reads the 'About Us' page and render all the properties.
      Please read comments above codes.

WARNING: This example is only for demonstration purpose. It's not optimized at all!
--%>

<%@ page language="java" import="javax.jcr.*, org.hippoecm.repository.*, org.hippoecm.hst.site.*" %>

<%
// document title property
String title = "";
// document introduction property
String introduction = "";
// document body html property
String bodyHtml = "";

HippoRepository hippoRepository = null;
Session jcrSession = null;

try {
    // get hippo repository from the jcr/webdav url.
    // if a session-pool is used, then this will be done automatically inside the pool implementation with the repository url.
    // for your information, in HST-2, the repository url is configured in *.repository.address properties in hst-config.properties.
    hippoRepository = HippoRepositoryFactory.getHippoRepository("java:comp/env/jcr/davexRepository");

    // for demo purpose, use hard-coded credentials
    String username = "admin";
    String password = "admin";
    // get jcr session from the hippo repository with the username/password.
    jcrSession = hippoRepository.login(new SimpleCredentials(username, password.toCharArray()));

    // example document path
    String documentNodePath = "content/documents/hipporepojcrdavdemo/content/sample-document/sample-document";
    // get document node
    Node documentNode = jcrSession.getRootNode().getNode(documentNodePath);
    // get title property
    title = documentNode.getProperty("hipporepojcrdavdemo:title").getString();
    // get summary property
    introduction = documentNode.getProperty("hipporepojcrdavdemo:introduction").getString();
    // get html body subnode
    Node bodyNode = documentNode.getNode("hipporepojcrdavdemo:content");
    // get content body html property
    bodyHtml = bodyNode.getProperty("hippostd:content").getString();
} finally {
    // close jcr session
    if (jcrSession != null) {
        jcrSession.logout();
    }
    // close hippo repository
    // this is just for demonstration purpose.
    // normally this hippo repository instance will be kept in the application lifecycle like hst session pool does.
    if (hippoRepository != null) {
        hippoRepository.close();
    }
}
%>

<html>
  <head>
    <title><%=title%></title>
  </head>
  <body>
    <h1><%=title%></h1>
    <p><%=introduction%></p>
    <div><%=bodyHtml%></div>
  </body>
</html>
