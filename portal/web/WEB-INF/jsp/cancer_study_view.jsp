<%@page import="org.json.simple.JSONValue"%>
<%@ page import="org.mskcc.portal.servlet.QueryBuilder" %>
<%@ page import="org.mskcc.portal.servlet.CancerStudyView" %>
<%@ page import="org.mskcc.cgds.model.CancerStudy" %>
<%@ page import="org.mskcc.cgds.model.GeneticProfile" %>
<%@ page import="org.mskcc.portal.util.SkinUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.json.simple.JSONValue" %>

<%
request.setAttribute("standard_js_only", true);
String isDemoMode = request.getParameter("demo");
boolean showPlaceHoder;
if (isDemoMode!=null) {
    showPlaceHoder = isDemoMode.equalsIgnoreCase("on");
} else {
    showPlaceHoder = SkinUtil.showPlaceholderInPatientView();
}

CancerStudy cancerStudy = (CancerStudy)request.getAttribute(CancerStudyView.CANCER_STUDY);
String cancerStudyViewError = (String)request.getAttribute(CancerStudyView.ERROR);

String caseSetId = (String)request.getAttribute(QueryBuilder.CASE_SET_ID);
List<String> caseIds = (List<String>)request.getAttribute(QueryBuilder.CASE_IDS);
String jsonCaseIds = JSONValue.toJSONString(caseIds);

GeneticProfile mutationProfile = (GeneticProfile)request.getAttribute(CancerStudyView.MUTATION_PROFILE);
boolean hasMutation = mutationProfile!=null;
boolean showMutationsTab = hasMutation;

GeneticProfile cnaProfile = (GeneticProfile)request.getAttribute(CancerStudyView.CNA_PROFILE);
boolean hasCNA = cnaProfile!=null;
boolean showCNATab = showPlaceHoder && hasCNA;

if (cancerStudyViewError!=null) {
    out.print(cancerStudyViewError);
} else {
%>

<jsp:include page="global/header.jsp" flush="true" />

<table width="100%">
    <tr>
        <td><b><u><%=cancerStudy.getName()%></u></b></td>
    </tr>
    <tr>
        <td><%=cancerStudy.getDescription()%></td>
    </tr>
</table>


<div id="study-tabs">
    <ul>
        
    <li><a href='#summary' class='study-tab' title='Events of Interest'>Summary</a></li>
    <li><a href='#data-table' class='study-tab' title='Events of Interest'>Clinical Data</a></li>
    
    <%if(showMutationsTab){%>
    <li><a href='#mutations' class='study-tab' title='Mutations'>Mutations</a></li>
    <%}%>
    
    <%if(showCNATab){%>
    <li><a href='#cna' class='study-tab' title='Copy Number Alterations'>Copy Number Alterations</a></li>
    <%}%>
    
    </ul>

    <div class="study-section" id="data-table">
        <%@ include file="cancer_study_view/data_table.jsp" %>
    </div>

    <div class="study-section" id="summary">
        <%@ include file="cancer_study_view/summary.jsp" %>
    </div>

    <%if(showMutationsTab){%>
    <div class="study-section" id="mutations">
        <%@ include file="cancer_study_view/mutations.jsp" %>
    </div>
    <%}%>

    <%if(showCNATab){%>
    <div class="study-section" id="cna">
        <%@ include file="cancer_study_view/cna.jsp" %>
    </div>
    <%}%>

</div>
<%  
}
%>
        </div>
    </td>
</tr>

<tr>
    <td colspan="3">
	<jsp:include page="global/footer.jsp" flush="true" />
    </td>
</tr>

</table>
</center>
</div>
<jsp:include page="global/xdebug.jsp" flush="true" />    

<script type="text/javascript" src="js/cancer-study-view.clinical-data.js"></script>

<script type="text/javascript">
var studyId = '<%=cancerStudy.getCancerStudyStableId()%>';
var mutationProfileId = <%=mutationProfile==null%>?null:'<%=mutationProfile.getStableId()%>';
var cnaProfileId = <%=cnaProfile==null%>?null:'<%=cnaProfile.getStableId()%>';
var caseSetId = '<%=caseSetId%>';
var caseIds = <%=jsonCaseIds%>;

$(document).ready(function(){
    setUpStudyTabs();
    initTabs();
});

function setUpStudyTabs() {
    $('#study-tabs').tabs();
    $('#study-tabs').show();
}

function initTabs() {
    var tabContainers = $('.study-section');
    tabContainers.hide().filter(':first').show();

    $('.study-tab').click(function () {
            tabContainers.hide();
            tabContainers.filter(this.hash).show();
            $('.study-tab').removeClass('selected');
            $(this).addClass('selected');
            return false;
    }).filter(':first').click();   
}

function switchToTab(toTab) {
    $('.study-section').hide();
    $('.study-section#'+toTab).show();
    $('#study-tabs').tabs('select',$('#study-tabs ul a[href="#'+toTab+'"]').parent().index());
}

</script>

</body>
</html>