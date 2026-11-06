<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_js_functions.xsl"/>
    <xsl:include href="../common/core_doctype.xsl"/>
    <xsl:include href="../common/core_common_head_content.xsl"/>
    <xsl:include href="../common/core_header.xsl"/>
    <xsl:include href="../common/core_footer.xsl"/>
    <xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/core_api_fetcher.xsl"/>
    <xsl:include href="../common/core_handlebars_functions.xsl"/>
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
    <xsl:param name="param1"/>
    <xsl:param name="viewScopeTermIds"/>
    <xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
    <xsl:variable name="linkClasses" select="('Enterprise_Strategic_Plan', 'Roadmap')"/>

    <!-- XSL Variables for embedded performance measure data -->
    <xsl:variable name="allStrategicPlans" select="/node()/simple_instance[type='Enterprise_Strategic_Plan']"/>
    <xsl:variable name="planPerfMeasureInstances" select="/node()/simple_instance[supertype='Performance_Measure'][name=$allStrategicPlans/own_slot_value[slot_reference='performance_measures']/value]"/>
    <xsl:variable name="planPerfCategories" select="/node()/simple_instance[type='Performance_Measure_Category'][name=$planPerfMeasureInstances/own_slot_value[slot_reference='pm_category']/value]"/>
    <xsl:variable name="planSQValues" select="/node()/simple_instance[supertype='Service_Quality_Value'][name=$planPerfMeasureInstances/own_slot_value[slot_reference='pm_performance_value']/value]"/>

    <xsl:template match="knowledge_base">
        <xsl:call-template name="docType"/>
        <html>
            <head>
                <xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent">
                    <xsl:with-param name="essModalClassNames" select="$linkClasses"/>
                </xsl:call-template>
                <title>Strategic Plan Data Completeness Report</title>
                <style>
                    .view-wrapper{padding:20px;max-width:1600px;margin:80px auto 0 auto}
                    .overall-score{text-align:center;margin-bottom:30px}
                    .overall-score .score-circle{display:inline-flex;align-items:center;justify-content:center;width:120px;height:120px;border-radius:50%;font-size:32px;font-weight:700;color:#fff}
                    .overall-score .score-label{display:block;margin-top:8px;font-size:14px;color:#666}
                    .roadmap-section{margin-bottom:30px;border:1px solid #e0e0e0;border-radius:8px;padding:20px}
                    .roadmap-section h3{margin-top:0;color:#333;border-bottom:1px solid #e0e0e0;padding-bottom:8px}
                    .roadmap-score{font-size:18px;font-weight:600;margin-bottom:15px}
                    .plan-table{width:100%;border-collapse:collapse;font-size:13px}
                    .plan-table th{background:#f5f5f5;padding:10px 8px;text-align:left;border-bottom:2px solid #ddd;font-weight:600;position:sticky;top:0}
                    .plan-table td{padding:8px;border-bottom:1px solid #eee;vertical-align:middle}
                    .plan-table tr:hover{background:#f9f9f9;cursor:pointer}
                    .check{color:#70ad47;font-weight:700}
                    .cross{color:#e74c3c;font-weight:700}
                    .score-bar{display:inline-block;height:8px;border-radius:4px;vertical-align:middle;margin-right:8px}
                    .score-text{font-weight:600;font-size:12px}
                    .score-cell{white-space:nowrap}
                    .filter-bar{display:flex;gap:15px;margin-bottom:20px;flex-wrap:wrap;align-items:center}
                    .filter-bar select{padding:6px 12px;border-radius:4px;border:1px solid #ccc;min-width:180px}
                    .filter-bar label{font-weight:600;margin-right:5px}
                    .summary-row{display:flex;gap:20px;margin-bottom:25px;flex-wrap:wrap}
                    .summary-stat{background:#fff;border:1px solid #e0e0e0;border-radius:8px;padding:15px 25px;text-align:center;min-width:120px}
                    .summary-stat .val{font-size:28px;font-weight:700}
                    .summary-stat .lbl{font-size:12px;color:#666;margin-top:4px}
                    .progress-bar-bg{width:100px;height:8px;background:#e0e0e0;border-radius:4px;display:inline-block;vertical-align:middle;margin-right:6px}
                    .progress-bar-fill{height:100%;border-radius:4px}
                    .detail-panel{position:fixed;top:0;right:-520px;width:500px;height:100vh;background:#fff;box-shadow:-4px 0 20px rgba(0,0,0,0.15);z-index:1000;transition:right 0.3s ease;overflow-y:auto;padding:30px}
                    .detail-panel.open{right:0}
                    .detail-panel .close-btn{position:absolute;top:15px;right:15px;font-size:24px;cursor:pointer;color:#666;background:none;border:none}
                    .detail-panel h3{margin-top:0;padding-right:40px;color:#333;border-bottom:2px solid #5b9bd5;padding-bottom:10px}
                    .detail-item{display:flex;align-items:flex-start;padding:10px 0;border-bottom:1px solid #f0f0f0}
                    .detail-item .di-status{width:28px;flex-shrink:0;font-size:18px;text-align:center}
                    .detail-item .di-content{flex:1}
                    .detail-item .di-label{font-weight:600;font-size:13px;color:#333}
                    .detail-item .di-value{font-size:12px;color:#666;margin-top:2px}
                    .detail-item.missing{background:#fff5f5}
                    .detail-item.present{background:#f5fff5}
                    .overlay{position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.3);z-index:999;display:none}
                    .overlay.open{display:block}
                </style>
                <script type="text/javascript">
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>
                    var planDataAPI, ImpTechCapApi;
                    var allPlans = [];
                    var allRoadmaps = [];
                    var planPerfMeasures = [<xsl:for-each select="$allStrategicPlans"><xsl:variable name="thisPlanPerfMeasures" select="$planPerfMeasureInstances[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/><xsl:if test="$thisPlanPerfMeasures">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","count":<xsl:value-of select="count($thisPlanPerfMeasures)"/>,"measures":[<xsl:for-each select="$thisPlanPerfMeasures"><xsl:variable name="thisCat" select="$planPerfCategories[name=current()/own_slot_value[slot_reference='pm_category']/value]"/><xsl:variable name="thisSQV" select="$planSQValues[name=current()/own_slot_value[slot_reference='pm_performance_value']/value][1]"/>{"category":"<xsl:value-of select="eas:getSafeJSString(string($thisCat[1]/own_slot_value[slot_reference='name']/value))"/>","value":"<xsl:value-of select="eas:getSafeJSString(string($thisSQV/own_slot_value[slot_reference='name']/value))"/>"}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,</xsl:if></xsl:if></xsl:for-each>];
                    var selectedRoadmapFilter = 'all';

                    // Completeness criteria
                    var REQUIRED_PERF_MEASURES = 10;
                    var criteria = [
                        {key: 'name', label: 'Name', check: function(p) { return p.name &amp;&amp; p.name.trim() !== ''; }},
                        {key: 'description', label: 'Description', check: function(p) { return p.description &amp;&amp; p.description.trim() !== ''; }},
                        {key: 'startDate', label: 'Start Date', check: function(p) { return p.validStartDate &amp;&amp; p.validStartDate.trim() !== ''; }},
                        {key: 'endDate', label: 'End Date', check: function(p) { return p.validEndDate &amp;&amp; p.validEndDate.trim() !== ''; }},
                        {key: 'status', label: 'Status', check: function(p) { return p.planStatus &amp;&amp; p.planStatus !== 'Not Set' &amp;&amp; p.planStatus.trim() !== ''; }},
                        {key: 'sponsor', label: 'Initiative Sponsor', check: function(p) { return p.stakeholders &amp;&amp; p.stakeholders.length &gt; 0; }},
                        {key: 'objectives', label: 'Business Objectives', check: function(p) { return p.objectives &amp;&amp; p.objectives.length &gt; 0; }},
                        {key: 'dependencies', label: 'Dependencies', check: function(p) { return p.dependsOn &amp;&amp; p.dependsOn.length &gt; 0; }},
                        {key: 'plannedChanges', label: 'Planned Changes', check: function(p) { return p.planP2E &amp;&amp; p.planP2E.length &gt; 0; }},
                        {key: 'perfMeasures', label: 'Perf Measures', check: function(p) { return getPerfMeasureCount(p.id) &gt;= REQUIRED_PERF_MEASURES; }, showCount: true}
                    ];

                    function getPerfMeasureCount(planId) {
                        var entry = planPerfMeasures.find(function(pm) { return pm.id === planId; });
                        return entry ? entry.count : 0;
                    }

                    $(document).ready(function() {
                        var apiList = ['planDataAPI'];
                        async function executeFetchAndRender() {
                            try {
                                var responses = await fetchAndRenderData(apiList);
                                planDataAPI = responses.planDataAPI;
                                allPlans = planDataAPI.allPlans || [];
                                allRoadmaps = planDataAPI.roadmaps || [];
                                buildFilters();
                                renderReport();
                            } catch (error) {
                                console.error('Error loading view data:', error);
                            }
                        }
                        executeFetchAndRender();
                    });

                    function buildFilters() {
                        var roadmapSelect = document.getElementById('filterRoadmap');
                        roadmapSelect.innerHTML = '&lt;option value="all"&gt;All Roadmaps&lt;/option&gt;';
                        allRoadmaps.forEach(function(rm) {
                            var opt = document.createElement('option');
                            opt.value = rm.id;
                            opt.textContent = rm.name;
                            roadmapSelect.appendChild(opt);
                        });
                        roadmapSelect.addEventListener('change', function() {
                            selectedRoadmapFilter = this.value;
                            renderReport();
                        });
                    }

                    function getRoadmapForPlan(planId) {
                        for (var i = 0; i &lt; allRoadmaps.length; i++) {
                            var rm = allRoadmaps[i];
                            if (rm.strategicPlans &amp;&amp; rm.strategicPlans.indexOf(planId) !== -1) {
                                return rm;
                            }
                        }
                        return null;
                    }

                    function getFilteredPlans() {
                        var plansWithRoadmap = allPlans.filter(function(p) {
                            return getRoadmapForPlan(p.id) !== null;
                        });
                        if (selectedRoadmapFilter === 'all') return plansWithRoadmap;
                        var rm = allRoadmaps.find(function(r) { return r.id === selectedRoadmapFilter; });
                        if (!rm) return plansWithRoadmap;
                        var ids = rm.strategicPlans || [];
                        return plansWithRoadmap.filter(function(p) { return ids.indexOf(p.id) !== -1; });
                    }

                    function scorePlan(plan) {
                        var passed = 0;
                        criteria.forEach(function(c) {
                            if (c.check(plan)) passed++;
                        });
                        return Math.round((passed / criteria.length) * 100);
                    }

                    function getScoreColour(score) {
                        if (score &gt;= 80) return '#70ad47';
                        if (score &gt;= 50) return '#ed7d31';
                        return '#e74c3c';
                    }

                    function renderReport() {
                        var plans = getFilteredPlans();
                        var totalScore = 0;
                        var planScores = plans.map(function(p) {
                            var score = scorePlan(p);
                            totalScore += score;
                            return {plan: p, score: score};
                        });
                        var overallScore = plans.length &gt; 0 ? Math.round(totalScore / plans.length) : 0;
                        var overallColour = getScoreColour(overallScore);

                        // Summary
                        var fullPlans = planScores.filter(function(ps) { return ps.score === 100; }).length;
                        var partialPlans = planScores.filter(function(ps) { return ps.score &gt; 0 &amp;&amp; ps.score &lt; 100; }).length;
                        var emptyPlans = planScores.filter(function(ps) { return ps.score === 0; }).length;

                        document.getElementById('overallCircle').style.background = overallColour;
                        document.getElementById('overallCircle').textContent = overallScore + '%';
                        document.getElementById('statTotal').textContent = plans.length;
                        document.getElementById('statComplete').textContent = fullPlans;
                        document.getElementById('statPartial').textContent = partialPlans;
                        document.getElementById('statEmpty').textContent = emptyPlans;

                        // Roadmap scores at top
                        var rmScoresHtml = '';
                        allRoadmaps.forEach(function(rm) {
                            var rmPlanIds = rm.strategicPlans || [];
                            var rmPlans = planScores.filter(function(ps) { return rmPlanIds.indexOf(ps.plan.id) !== -1; });
                            if (rmPlans.length === 0) return;
                            var rmTotal = 0;
                            rmPlans.forEach(function(ps) { rmTotal += ps.score; });
                            var rmAvg = Math.round(rmTotal / rmPlans.length);
                            var rmColour = getScoreColour(rmAvg);
                            rmScoresHtml += '&lt;div class="summary-stat"&gt;&lt;div class="val" style="color:' + rmColour + '"&gt;' + rmAvg + '%&lt;/div&gt;&lt;div class="lbl"&gt;' + rm.name + '&lt;/div&gt;&lt;/div&gt;';
                        });
                        document.getElementById('roadmapScores').innerHTML = rmScoresHtml;

                        // Group by roadmap
                        var grouped = {};
                        planScores.forEach(function(ps) {
                            var rm = getRoadmapForPlan(ps.plan.id);
                            var rmName = rm ? rm.name : 'Unassigned';
                            if (!grouped[rmName]) grouped[rmName] = [];
                            grouped[rmName].push(ps);
                        });

                        var html = '';
                        Object.keys(grouped).sort().forEach(function(rmName) {
                            var group = grouped[rmName];
                            var rmTotal = 0;
                            group.forEach(function(ps) { rmTotal += ps.score; });
                            var rmAvg = Math.round(rmTotal / group.length);
                            var rmColour = getScoreColour(rmAvg);

                            html += '&lt;div class="roadmap-section"&gt;';
                            html += '&lt;h3&gt;' + rmName + '&lt;/h3&gt;';
                            html += '&lt;div class="roadmap-score"&gt;Roadmap Completeness: &lt;span style="color:' + rmColour + '"&gt;' + rmAvg + '%&lt;/span&gt;&lt;/div&gt;';
                            html += '&lt;table class="plan-table"&gt;';
                            html += '&lt;thead&gt;&lt;tr&gt;&lt;th&gt;Plan&lt;/th&gt;&lt;th&gt;Score&lt;/th&gt;';
                            criteria.forEach(function(c) {
                                html += '&lt;th style="text-align:center;font-size:11px;"&gt;' + c.label + '&lt;/th&gt;';
                            });
                            html += '&lt;/tr&gt;&lt;/thead&gt;&lt;tbody&gt;';

                            group.sort(function(a, b) { return a.score - b.score; }).forEach(function(ps) {
                                var colour = getScoreColour(ps.score);
                                html += '&lt;tr onclick="showPlanDetail(\'' + ps.plan.id + '\')"&gt;';
                                html += '&lt;td style="font-weight:500;max-width:250px;color:#5b9bd5;text-decoration:underline;"&gt;' + ps.plan.name + '&lt;/td&gt;';
                                html += '&lt;td class="score-cell"&gt;&lt;div class="progress-bar-bg"&gt;&lt;div class="progress-bar-fill" style="width:' + ps.score + '%;background:' + colour + ';"&gt;&lt;/div&gt;&lt;/div&gt;&lt;span class="score-text" style="color:' + colour + '"&gt;' + ps.score + '%&lt;/span&gt;&lt;/td&gt;';
                                criteria.forEach(function(c) {
                                    var passed = c.check(ps.plan);
                                    if (c.showCount) {
                                        var count = getPerfMeasureCount(ps.plan.id);
                                        var colour = count &gt;= REQUIRED_PERF_MEASURES ? '#70ad47' : '#e74c3c';
                                        html += '&lt;td style="text-align:center;font-weight:600;color:' + colour + '"&gt;' + count + '/10&lt;/td&gt;';
                                    } else {
                                        html += '&lt;td style="text-align:center;"&gt;' + (passed ? '&lt;span class="check"&gt;&#x2713;&lt;/span&gt;' : '&lt;span class="cross"&gt;&#x2717;&lt;/span&gt;') + '&lt;/td&gt;';
                                    }
                                });
                                html += '&lt;/tr&gt;';
                            });

                            html += '&lt;/tbody&gt;&lt;/table&gt;&lt;/div&gt;';
                        });

                        document.getElementById('reportContent').innerHTML = html;
                    }

                    function showPlanDetail(planId) {
                        var plan = allPlans.find(function(p) { return p.id === planId; });
                        if (!plan) return;
                        var score = scorePlan(plan);
                        var colour = getScoreColour(score);
                        var perfCount = getPerfMeasureCount(planId);

                        var html = '&lt;h3&gt;' + plan.name + '&lt;/h3&gt;';
                        html += '&lt;p style="font-size:16px;margin-bottom:20px;"&gt;Completeness: &lt;strong style="color:' + colour + '"&gt;' + score + '%&lt;/strong&gt;&lt;/p&gt;';

                        // Show each criterion with its data
                        var details = [
                            {label: 'Name', present: plan.name &amp;&amp; plan.name.trim() !== '', value: plan.name || ''},
                            {label: 'Description', present: plan.description &amp;&amp; plan.description.trim() !== '', value: plan.description ? plan.description.substring(0, 150) + (plan.description.length &gt; 150 ? '...' : '') : ''},
                            {label: 'Start Date', present: plan.validStartDate &amp;&amp; plan.validStartDate.trim() !== '', value: plan.validStartDate || ''},
                            {label: 'End Date', present: plan.validEndDate &amp;&amp; plan.validEndDate.trim() !== '', value: plan.validEndDate || ''},
                            {label: 'Status', present: plan.planStatus &amp;&amp; plan.planStatus !== 'Not Set' &amp;&amp; plan.planStatus.trim() !== '', value: plan.planStatus || ''},
                            {label: 'Initiative Sponsor (Stakeholders)', present: plan.stakeholders &amp;&amp; plan.stakeholders.length &gt; 0, value: plan.stakeholders ? plan.stakeholders.length + ' stakeholder(s)' : '0'},
                            {label: 'Business Objectives', present: plan.objectives &amp;&amp; plan.objectives.length &gt; 0, value: plan.objectives ? plan.objectives.length + ' objective(s)' : '0'},
                            {label: 'Dependencies', present: plan.dependsOn &amp;&amp; plan.dependsOn.length &gt; 0, value: plan.dependsOn ? plan.dependsOn.length + ' dependency(ies)' : '0'},
                            {label: 'Planned Changes (P2E)', present: plan.planP2E &amp;&amp; plan.planP2E.length &gt; 0, value: plan.planP2E ? plan.planP2E.length + ' planned change(s)' : '0'},
                            {label: 'Performance Measures (need 10)', present: perfCount &gt;= REQUIRED_PERF_MEASURES, value: perfCount + ' of 10'}
                        ];

                        details.forEach(function(d) {
                            var cls = d.present ? 'present' : 'missing';
                            var icon = d.present ? '&lt;span class="check"&gt;&#x2713;&lt;/span&gt;' : '&lt;span class="cross"&gt;&#x2717;&lt;/span&gt;';
                            html += '&lt;div class="detail-item ' + cls + '"&gt;';
                            html += '&lt;div class="di-status"&gt;' + icon + '&lt;/div&gt;';
                            html += '&lt;div class="di-content"&gt;&lt;div class="di-label"&gt;' + d.label + '&lt;/div&gt;';
                            if (d.present) {
                                html += '&lt;div class="di-value"&gt;' + d.value + '&lt;/div&gt;';
                            } else {
                                html += '&lt;div class="di-value" style="color:#e74c3c;font-style:italic;"&gt;Missing&lt;/div&gt;';
                            }
                            html += '&lt;/div&gt;&lt;/div&gt;';
                        });

                        // List actual performance measures
                        var planPerf = planPerfMeasures.find(function(pm) { return pm.id === planId; });
                        var measures = planPerf ? planPerf.measures || [] : [];
                        var expectedCategories = ['Priority', 'DSP_-_Change_Impact', 'DSP_-_Financial_Size', 'DSP_-_Complexity', 'Benefit_-_Cashable', 'Benefit_-_Non-cashable', 'Benefit_-_User_Experience_(non-financial)', 'Benefit_-_Future_Readiness_(non-financial)', 'Benefit_-_Management_Insight_(non-financial)', 'Benefit_-_Compliance_(non-financial)'];
                        var presentCategories = measures.map(function(m) { return m.category; });
                        var missingCategories = expectedCategories.filter(function(cat) {
                            return presentCategories.indexOf(cat) === -1;
                        });

                        html += '&lt;div style="margin-top:20px;border-top:2px solid #5b9bd5;padding-top:15px;"&gt;';
                        html += '&lt;h4 style="margin:0 0 10px 0;color:#333;"&gt;Performance Measures (' + measures.length + '/10)&lt;/h4&gt;';
                        if (missingCategories.length &gt; 0) {
                            html += '&lt;p style="font-size:12px;color:#e74c3c;font-weight:600;margin-bottom:8px;"&gt;Missing (' + missingCategories.length + '):&lt;/p&gt;';
                            html += '&lt;ul style="margin:0 0 10px 0;padding-left:20px;"&gt;';
                            missingCategories.forEach(function(cat) {
                                html += '&lt;li style="color:#e74c3c;font-size:12px;margin-bottom:4px;"&gt;' + cat.replace(/_/g, ' ') + '&lt;/li&gt;';
                            });
                            html += '&lt;/ul&gt;';
                        } else {
                            html += '&lt;p style="color:#70ad47;font-weight:600;font-size:12px;"&gt;All performance measures complete.&lt;/p&gt;';
                        }
                        html += '&lt;/div&gt;';

                        document.getElementById('detailContent').innerHTML = html;
                        document.getElementById('detailPanel').classList.add('open');
                        document.getElementById('overlay').classList.add('open');
                    }

                    function closeDetail() {
                        document.getElementById('detailPanel').classList.remove('open');
                        document.getElementById('overlay').classList.remove('open');
                    }
                </script>
            </head>
            <body>
                <xsl:call-template name="Heading"/>
                <xsl:call-template name="ViewUserScopingUI"/>
                <div class="view-wrapper">
                    <h1 style="margin-bottom:5px;">Strategic Plan Data Completeness Report</h1>
                    <p style="color:#666;margin-bottom:20px;">Measures the completeness of strategic plan data against required fields.</p>

                    <div class="overall-score">
                        <div class="score-circle" id="overallCircle">0%</div>
                        <span class="score-label">Overall Completeness</span>
                    </div>

                    <div class="summary-row">
                        <div class="summary-stat"><div class="val" id="statTotal">0</div><div class="lbl">Total Plans</div></div>
                        <div class="summary-stat"><div class="val" id="statComplete" style="color:#70ad47;">0</div><div class="lbl">100% Complete</div></div>
                        <div class="summary-stat"><div class="val" id="statPartial" style="color:#ed7d31;">0</div><div class="lbl">Partial</div></div>
                        <div class="summary-stat"><div class="val" id="statEmpty" style="color:#e74c3c;">0</div><div class="lbl">Empty (0%)</div></div>
                    </div>

                    <div class="summary-row" id="roadmapScores"/>

                    <div class="filter-bar">
                        <div><label for="filterRoadmap">Roadmap:</label><select id="filterRoadmap"><option value="all">All Roadmaps</option></select></div>
                    </div>

                    <div id="reportContent"><p>Loading completeness report...</p></div>
                </div>
                <div class="overlay" id="overlay" onclick="closeDetail()"/>
                <div class="detail-panel" id="detailPanel">
                    <button class="close-btn" onclick="closeDetail()">x</button>
                    <div id="detailContent"/>
                </div>
                <xsl:call-template name="Footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
