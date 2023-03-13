/**
 * BSD 3-Clause License
 * Copyright (c) 2019 - Present, Rahul Malhotra All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice, 
 * this list of conditions and the following disclaimer in the documentation and/or 
 * other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of its contributors 
 * may be used to endorse or promote products derived from this software without 
 * specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * @description       : HTTP Callout Service based on this utility package: https://github.com/rahulmalhotra/HTTPCalloutFramework
 * @author            : Zachery Tapp Craftsman Technology Group
 * @group             : Rent Manager Integration
**/

public class HTTPService {

  private static final String TYPE_URL_PARAMS = 'URL_PARAMETERS';
  private static final String TYPE_HEADER_PARAMS = 'HEADER_PARAMETERS';

  HTTPCalloutConfiguration__mdt objHTTPConfig;
  String strEndpoint,
    strRequestMethod,
    strRequestBody,
    strRequestCert,
    strEndpointSuffix;
  Blob blobRequestBody;
  Dom.Document domRequestBody;
  Integer intTimeout;
  Map<String, String> mapURLParams;
  Map<String, String> mapHeaderParams;
  HttpRequest objRequest;

  public HTTPService() {
    initialize();
  }
  public HTTPService(String strSettingName) {
    objHTTPConfig = [SELECT Id, Method__c, HeaderParameters__c, Body__c, Endpoint__c, CertificateName__c, URLParameters__c FROM HTTPCalloutConfiguration__mdt WHERE DeveloperName =:strSettingName];
    objHTTPConfig = [
      SELECT
        Method__c,
        URLParameters__c,
        HeaderParameters__c,
        Endpoint__c,
        Body__c,
        Timeout__c,
        CertificateName__c
      FROM HTTPCalloutConfiguration__mdt
      WHERE DeveloperName = :strSettingName
    ];
    Logger.debug(String.valueOf(this.objHTTPConfig));
    Logger.saveLog();
    initialize();
  }

  /**
   * @description primary initialization method for the Service class
   */
  private void initialize() {
    mapURLParams = new Map<String, String>();
    mapHeaderParams = new Map<String, String>();
    if (objHTTPConfig != null) {
      strEndpoint = objHTTPConfig.Endpoint__c;
      strRequestMethod = objHTTPConfig.Method__c;
      strRequestBody = objHTTPConfig.Body__c;
      // intNumberOfResults = Integer.valueOf(objHTTPConfig.Number_of_Results__c);
      intTimeout = Integer.valueOf(objHTTPConfig.Timeout__c);
      setURLOrHeaderParams(TYPE_URL_PARAMS, objHTTPConfig.URLParameters__c);
      setURLOrHeaderParams(
        TYPE_HEADER_PARAMS,
        objHTTPConfig.HeaderParameters__c
      );
    }
  }

  /**
   * @description returns endpoint
   */
  public String getEndpoint() {
    return strEndpoint;
  }

  /**
   * @description sets the endpoint to return
   */
  public void setEndpoint(String strEndpoint) {
    this.strEndpoint = strEndpoint;
  }

  /**
   * @description returns request method
   */
  public String getRequestMethod() {
    return strRequestMethod;
  }

  /**
   * @description sets the request method
   */
  public void setRequestMethod(String strRequestMethod) {
    this.strRequestMethod = strRequestMethod;
  }

  /**
   * @description returns the request body as a string
   */
  public String getBody() {
    return strRequestBody;
  }

  /**
   * @description sets the request body string
   */
  public void setBody(String strRequestBody) {
    this.strRequestBody = strRequestBody;
  }

  /**
   * @description returns the request body as a blob
   */
  public Blob getRequestBodyAsBlob() {
    return blobRequestBody;
  }

  /**
   * @description sets the request body as a blob
   */
  public void setRequestBodyAsBlob(Blob blobRequestBody) {
    this.blobRequestBody = blobRequestBody;
  }

  /**
   * @description returns the request body as a DOM document
   */
  public Dom.Document getRequestBodyAsDom() {
    return domRequestBody;
  }

  /**
   * @description sets the request body as a DOM document
   */
  public void setRequestBodyAsDom(Dom.Document domRequestBody) {
    this.domRequestBody = domRequestBody;
  }

  /**
   * @description returns the timeout in seconds
   */
  public Integer getTimeout() {
    return intTimeout;
  }

  /**
   * @description sets the timeout in seconds
   */
  public void setTimeout(Integer intTimeout) {
    this.intTimeout = intTimeout;
  }

  /**
   * @description returns a single header parameter for a given key
   */
  public String getHeaderParameter(String key) {
    return mapHeaderParams.get(key);
  }

  /**
   * @description returns all header parameters
   */
  public Map<String, String> getHeaderParameters() {
    return mapHeaderParams;
  }

  /**
   * @description sets a key/value header parameter pair
   */
  public void setHeaderParameter(String key, String value) {
    if (String.isNotEmpty(key) && String.isNotEmpty(value)) {
      mapHeaderParams.put(key, value);
    }
  }

  /**
   * @description sets the endpoint stuffix - can be helpful for appending non-key/val pairs
   */
  public void setEndpointSuffix(String strEndpointSuffix) {
    if (String.isNotEmpty(strEndpointSuffix)) {
      this.strEndpointSuffix = strEndpointSuffix;
    }
  }

  /**
   * @description returns the endpoint suffix
   */
  public string getEndpointSuffix() {
    return this.strEndpointSuffix;
  }

  /**
   * @description removes a header parameter
   */
  public void removeHeaderParameter(String key) {
    mapHeaderParams.remove(key);
  }

  /**
   * @description returns a single URL parameter for a given key
   */
  public String getURLParameter(String key) {
    return mapURLParams.get(key);
  }

  /**
   * @description returns all URL parameters
   */
  public Map<String, String> getURLParameters() {
    return mapURLParams;
  }

  /**
   * @description adds key/valua pair to URL parameters
   */
  public void setURLParameter(String key, String value) {
    if (String.isNotEmpty(key) && String.isNotEmpty(value)) {
      mapURLParams.put(key, value);
    } else if (String.isNotEmpty(key)) {
      mapURLParams.put(key, value);
    }
  }

  /**
   * @description sets the header and URL parameters for the Service
   * @param strParamInfo the body from the metadata that holds all the key/value pairs
   * @param strParamType either the header type or URL type defined in member variables above
   */
  private void setURLOrHeaderParams(String strParamType, String strParamInfo) {
    if (String.isNotEmpty(strParamInfo)) {
      Map<String, String> mapParams = new Map<String, String>();
      List<String> lstParams = strParamInfo.split('\n'); // Split on line break.
      for (String urlParam : lstParams) {
        List<String> lstKeyValPair = urlParam.trim().split(':'); // Split on colon (see Custom Metadata)
        if (!lstKeyValPair.isEmpty()) {
          if (lstKeyValPair.size() == 2) {
            if (
              String.isNotEmpty(lstKeyValPair[0]) &&
              String.isNotEmpty(lstKeyValPair[1])
            ) {
              mapParams.put(lstKeyValPair[0], lstKeyValPair[1]);
            }
          } else if (
            lstKeyValPair.size() == 1 && (strParamType == TYPE_HEADER_PARAMS)
          ) {
            if (String.isNotBlank(lstKeyValPair[0])) {
              mapParams.put(lstKeyValPair[0], '');
            }
          }
        }
      }
      if (strParamType == TYPE_URL_PARAMS) {
        mapURLParams.putAll(mapParams);
      } else if (strParamType == TYPE_HEADER_PARAMS) {
        mapHeaderParams.putAll(mapParams);
      }
    }
  }

  /**
   * @description appends all URL parameters back to the end of the URL
   */
  private void appendURLParameters() {
    Set<String> setURLParamKeys = mapURLParams.keySet();
    if (!setURLParamKeys.isEmpty()) {
      strEndpoint += '?';
      for (String strParamKey : setURLParamKeys) {
        strEndpoint += strParamKey + '=' + mapURLParams.get(strParamKey) + '&';
      }
      strEndpoint = strEndpoint.substringBeforeLast('&');
    }

    if (String.isNotEmpty(this.strEndpointSuffix)) {
      strEndpoint += '&' + this.strEndpointSuffix;
    }
  }

  /**
   * @description used to add headers to request object
   */
  private void addHeaderParameters() {
    for (String strKey : mapHeaderParams.keySet()) {
      objRequest.setHeader(strKey, mapHeaderParams.get(strKey));
    }
  }

  /**
   * @description builds the HTTPRequest object for future processing
   */
  public void buildHTTPRequest() {
    objRequest = new HttpRequest();
    addHeaderParameters();

    if (String.isNotEmpty(this.strEndpoint)) {
      this.strEndpoint = strEndpoint.substringBefore('?');
      appendURLParameters();
      objRequest.setEndpoint(strEndpoint);
    }

    if (String.isNotEmpty(this.strRequestMethod)) {
      objRequest.setMethod(this.strRequestMethod);
    }

    if (String.isNotEmpty(this.strRequestBody)) {
      objRequest.setBody(this.strRequestBody);
    } else if (
      (this.blobRequestBody != null) &&
      String.isNotEmpty(this.blobRequestBody.toString())
    ) {
      objRequest.setBodyAsBlob(this.blobRequestBody);
    } else if (
      (this.domRequestBody != null) &&
      String.isNotEmpty(this.domRequestBody.toXmlString())
    ) {
      objRequest.setBodyDocument(this.domRequestBody);
    }

    if (this.intTimeout != null) {
      objRequest.setTimeout(this.intTimeout);
    }
  }

  /**
   * @description gets the HTTPRequest object for processing
   */
  public HttpRequest getRequest() {
    buildHTTPRequest();
    return this.objRequest;
  }

  /**
   * @description sends the HTTP request and return a response
   */
  public HttpResponse sendRequest() {
    buildHTTPRequest();
    HTTP objHTTP = new HTTP();
    return objHTTP.send(this.objRequest);
  }

  /**
   * @description used to send HTTP Request recieved in parameter and return the response
   */
  public HttpResponse sendRequest(HttpRequest objRequest) {
    HTTP objHTTP = new HTTP();
    return objHTTP.send(objRequest);
  }
}