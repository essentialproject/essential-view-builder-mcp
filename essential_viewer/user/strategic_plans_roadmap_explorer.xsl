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
    <xsl:variable name="linkClasses" select="('Enterprise_Strategic_Plan', 'Roadmap', 'Technology_Capability')"/>

    <!-- XSL Variables to query performance measures for plans -->
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
                <title>Explore UCL's Digital Strategic Plan</title>
                <style>
                    .view-wrapper{padding:20px;max-width:1600px;margin:80px auto 0 auto}
                    .filters-bar{display:flex;gap:15px;margin-bottom:20px;flex-wrap:wrap;align-items:center}
                    .filters-bar select{padding:6px 12px;border-radius:4px;border:1px solid #ccc;min-width:180px}
                    .filters-bar label{font-weight:600;margin-right:5px}
                    .filters-bar .toggle-label{display:inline-flex;align-items:center;gap:6px;cursor:pointer;margin-right:0}
                    .filters-bar .toggle-label input{cursor:pointer}
                    .priority-group{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
                    .priority-checks{display:flex;flex-wrap:wrap;gap:6px}
                    .pr-chk{display:inline-flex;align-items:center;gap:5px;background:#fff;border:1px solid #ccc;border-radius:16px;padding:4px 11px;cursor:pointer;font-size:12px;font-weight:600;color:#444;user-select:none}
                    .pr-chk:hover{background:#f3f3f3}
                    .pr-chk.checked{background:#e8f0fb;border-color:#5b9bd5;color:#2c5f96}
                    .pr-chk input{cursor:pointer}
                    .pr-actions{font-size:12px;font-weight:600}
                    .pr-actions a{color:#5b9bd5;cursor:pointer;text-decoration:underline;margin-left:8px}
                    .roadmap-container{position:relative;overflow-x:auto;margin-bottom:30px;border:1px solid #e0e0e0;border-radius:8px;padding:20px;background:#fafafa}
                    .timeline-header{display:flex;border-bottom:2px solid #ccc;padding-bottom:8px;margin-bottom:10px;position:sticky;top:0;background:#fafafa;z-index:2}
                    .timeline-label{width:280px;font-weight:700;flex-shrink:0}
                    .timeline-scale{flex:1;display:flex;justify-content:space-between;font-size:11px;color:#666}
                    .plan-row{display:flex;align-items:center;margin-bottom:8px;min-height:44px}
                    .plan-name{width:280px;font-size:12px;font-weight:500;flex-shrink:0;padding-right:10px;line-height:1.3;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
                    .plan-bar-container{flex:1;position:relative;height:28px}
                    .plan-bar{position:absolute;height:24px;border-radius:4px;cursor:pointer;display:flex;align-items:center;padding:0 8px;font-size:11px;color:#fff;font-weight:500;transition:opacity 0.2s,transform 0.1s;top:2px}
                    .plan-bar:hover{opacity:0.85;transform:scaleY(1.1)}
                    .plan-bar.status-backlog{background:#8E9BAE}
                    .plan-bar.status-idea{background:#5b9bd5}
                    .plan-bar.status-discovery{background:#ed7d31}
                    .plan-bar.status-governance{background:#9b59b6}
                    .plan-bar.status-inprogress{background:#70ad47}
                    .plan-bar.status-done{background:#2E7D32}
                    .plan-bar.status-default{background:#bdc3c7}
                    .detail-panel{position:fixed;top:0;right:-500px;width:480px;height:100vh;background:#fff;box-shadow:-4px 0 20px rgba(0,0,0,0.15);z-index:1000;transition:right 0.3s ease;overflow-y:auto;padding:30px}
                    .detail-panel.open{right:0}
                    .detail-panel .close-btn{position:absolute;top:15px;right:15px;font-size:24px;cursor:pointer;color:#666;background:none;border:none}
                    .detail-panel h3{margin-top:0;padding-right:40px;color:#333;border-bottom:2px solid #5b9bd5;padding-bottom:10px}
                    .detail-section{margin-bottom:20px}
                    .detail-section h4{color:#555;margin-bottom:8px;font-size:14px}
                    .detail-meta{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:15px}
                    .detail-meta .meta-item{background:#f5f5f5;padding:8px 12px;border-radius:4px}
                    .detail-meta .meta-label{font-size:11px;color:#888;text-transform:uppercase}
                    .detail-meta .meta-value{font-size:14px;font-weight:600;color:#333}
                    .perf-table{width:100%;border-collapse:collapse;font-size:13px}
                    .perf-table th{background:#f0f0f0;padding:8px;text-align:left;border-bottom:1px solid #ddd}
                    .perf-table td{padding:8px;border-bottom:1px solid #eee}
                    .dep-list{list-style:none;padding:0}
                    .dep-list li{padding:6px 10px;margin-bottom:4px;background:#fff3e0;border-left:3px solid #ff9800;border-radius:3px;font-size:13px}
                    .legend{display:flex;gap:15px;margin-bottom:15px;flex-wrap:wrap}
                    .legend-item{display:flex;align-items:center;gap:5px;font-size:12px}
                    .legend-swatch{width:16px;height:16px;border-radius:3px}
                    .summary-cards{display:flex;gap:15px;margin-bottom:20px;flex-wrap:wrap}
                    .summary-card{background:#fff;border:1px solid #e0e0e0;border-radius:8px;padding:15px 20px;min-width:140px;text-align:center}
                    .summary-card .count{font-size:28px;font-weight:700;color:#5b9bd5}
                    .summary-card .label{font-size:12px;color:#666;margin-top:4px}
                    .overlay{position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.3);z-index:999;display:none}
                    .overlay.open{display:block}
                    .no-data{text-align:center;padding:40px;color:#999;font-size:16px}
                </style>
                <script type="text/javascript">
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>
                    var planDataAPI, ImpTechCapApi;
                    var allPlans = [];
                    var allRoadmaps = [];
                    var allProjects = [];
                    var techCapabilities = [];
                    var planPerfMeasures = [<xsl:for-each select="$allStrategicPlans"><xsl:variable name="thisPlanPerfMeasures" select="$planPerfMeasureInstances[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/><xsl:if test="$thisPlanPerfMeasures">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","measures":[<xsl:for-each select="$thisPlanPerfMeasures"><xsl:variable name="thisCat" select="$planPerfCategories[name=current()/own_slot_value[slot_reference='pm_category']/value]"/><xsl:variable name="thisSQV" select="$planSQValues[name=current()/own_slot_value[slot_reference='pm_performance_value']/value][1]"/>{"category":"<xsl:value-of select="eas:getSafeJSString(string($thisCat[1]/own_slot_value[slot_reference='name']/value))"/>","value":"<xsl:value-of select="eas:getSafeJSString(string($thisSQV/own_slot_value[slot_reference='name']/value))"/>","score":"<xsl:value-of select="$thisSQV/own_slot_value[slot_reference='service_quality_value_score']/value"/>"}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,</xsl:if></xsl:if></xsl:for-each>];
                    var selectedRoadmapFilter = 'all';
                    // Multi-select priorities (additive). Default: all ticked. Empty set = show none.
                    var selectedPriorities = {};
                    var excludeBacklog = false;

                    // ---- Strategic plan status config (new DB values) ----
                    // Matches are prefix-tolerant: any leading "N. " is stripped before comparing.
                    // key -> used for CSS class (status-KEY) and summary counters.
                    var STATUS_DEFS = [
                        { key:'backlog',    label:'Backlog',     colour:'#8E9BAE' },
                        { key:'idea',       label:'Roadmap Idea', colour:'#5b9bd5', match:['roadmap idea'] },
                        { key:'discovery',  label:'Discovery',   colour:'#ed7d31' },
                        { key:'governance', label:'Governance',  colour:'#9b59b6' },
                        { key:'inprogress', label:'In Progress', colour:'#70ad47', match:['in progress'] },
                        { key:'done',       label:'Done',        colour:'#2E7D32' }
                    ];
                    function normStatus(s){ return (s || '').replace(/^\s*\d+\.\s*/, '').trim().toLowerCase(); }
                    function statusDef(s){
                        var n = normStatus(s);
                        for (var i = 0; i &lt; STATUS_DEFS.length; i++) {
                            var d = STATUS_DEFS[i];
                            var names = d.match || [d.label.toLowerCase()];
                            if (names.indexOf(n) !== -1) return d;
                        }
                        return null;
                    }
                    function statusKey(s){ var d = statusDef(s); return d ? d.key : 'default'; }
                    function isBacklog(p){ return statusKey(p.planStatus) === 'backlog'; }

                    $(document).ready(function() {
                        var apiList = ['planDataAPI', 'ImpTechCapApi'];
                        async function executeFetchAndRender() {
                            try {
                                var responses = await fetchAndRenderData(apiList);
                                planDataAPI = responses.planDataAPI;
                                ImpTechCapApi = responses.ImpTechCapApi;
                                console.log('planDataAPI:', planDataAPI);
                                console.log('ImpTechCapApi:', ImpTechCapApi);
                                console.log('Embedded planPerfMeasures:', planPerfMeasures);
                                allPlans = (planDataAPI.allPlans || []).filter(function(p) { return p.planStatus !== '0. Roadmap Idea (Outside DSP 25-32)'; });
                                allRoadmaps = planDataAPI.roadmaps || [];
                                allProjects = planDataAPI.allProject || [];
                                techCapabilities = ImpTechCapApi.technology_capabilities || [];
                                buildFilters();
                                renderView();
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
                        // Build priority options from planPerfMeasures - get unique values where category = Priority
                        var priorities = new Map();
                        planPerfMeasures.forEach(function(planPerf) {
                            if (planPerf.measures) {
                                planPerf.measures.forEach(function(m) {
                                    if (m.category &amp;&amp; m.category.toLowerCase().indexOf('priority') !== -1 &amp;&amp; m.value) {
                                        // Determine sort order from value name
                                        var order = 99;
                                        if (m.value.indexOf('Non-Negotiable') !== -1) order = 0;
                                        else if (m.value.indexOf('P1') !== -1) order = 1;
                                        else if (m.value.indexOf('P2') !== -1) order = 2;
                                        else if (m.value.indexOf('P3') !== -1) order = 3;
                                        else if (m.value.indexOf('P4') !== -1) order = 4;
                                        else if (m.value.indexOf('P5') !== -1) order = 5;
                                        else if (m.value.indexOf('P6') !== -1) order = 6;
                                        else if (m.value.indexOf('P7') !== -1) order = 7;
                                        else if (m.value.indexOf('P8') !== -1) order = 8;
                                        if (!priorities.has(m.value)) {
                                            priorities.set(m.value, order);
                                        }
                                    }
                                });
                            }
                        });
                        // Sort by order (Non-Negotiable=0, P1=1, P2=2... P8=8)
                        var sortedPriorities = Array.from(priorities.entries()).sort(function(a, b) { return a[1] - b[1]; });
                        // Render additive priority checkboxes, all ticked by default
                        selectedPriorities = {};
                        var prWrap = document.getElementById('priorityChecks');
                        var prHtml = '';
                        sortedPriorities.forEach(function(entry) {
                            var val = entry[0];
                            selectedPriorities[val] = true;
                            var safe = String(val).replace(/&amp;/g,'&amp;amp;').replace(/&lt;/g,'&amp;lt;').replace(/&gt;/g,'&amp;gt;').replace(/"/g,'&amp;quot;');
                            prHtml += '&lt;label class="pr-chk checked" data-priority="' + safe + '"&gt;'
                                + '&lt;input type="checkbox" value="' + safe + '" checked="checked" onchange="onPriorityToggle(this)"/&gt;'
                                + safe + '&lt;/label&gt;';
                        });
                        prWrap.innerHTML = prHtml || '&lt;span style="color:#999;font-size:12px;"&gt;No priorities found&lt;/span&gt;';

                        roadmapSelect.addEventListener('change', function() {
                            selectedRoadmapFilter = this.value;
                            renderView();
                        });
                        var exBacklog = document.getElementById('excludeBacklog');
                        if (exBacklog) {
                            exBacklog.addEventListener('change', function() {
                                excludeBacklog = this.checked;
                                renderView();
                            });
                        }
                    }

                    function priorityCount() { return document.querySelectorAll('#priorityChecks input[type=checkbox]').length; }
                    function onPriorityToggle(cb) {
                        if (cb.checked) { selectedPriorities[cb.value] = true; }
                        else { delete selectedPriorities[cb.value]; }
                        if (cb.parentNode) cb.parentNode.classList.toggle('checked', cb.checked);
                        renderView();
                    }
                    function priorityAll() {
                        var boxes = document.querySelectorAll('#priorityChecks input[type=checkbox]');
                        boxes.forEach(function(b){ b.checked = true; selectedPriorities[b.value] = true; b.parentNode.classList.add('checked'); });
                        renderView();
                    }
                    function priorityNone() {
                        selectedPriorities = {};
                        var boxes = document.querySelectorAll('#priorityChecks input[type=checkbox]');
                        boxes.forEach(function(b){ b.checked = false; b.parentNode.classList.remove('checked'); });
                        renderView();
                    }

                    function getPlansForRoadmap(roadmapId) {
                        var rm = allRoadmaps.find(function(r) { return r.id === roadmapId; });
                        if (!rm) return [];
                        return rm.strategicPlans || [];
                    }

                    function filterPlans() {
                        var filtered = allPlans.slice();
                        if (selectedRoadmapFilter !== 'all') {
                            var planIdsInRoadmap = getPlansForRoadmap(selectedRoadmapFilter);
                            filtered = filtered.filter(function(plan) {
                                return planIdsInRoadmap.indexOf(plan.id) !== -1;
                            });
                        }
                        // Priority: additive checkboxes. A plan shows if its priority is ticked.
                        // Plans with no priority show only when all priorities are ticked (the default "show everything").
                        var chosen = Object.keys(selectedPriorities);
                        var allTicked = (chosen.length === priorityCount());
                        filtered = filtered.filter(function(plan) {
                            var pr = getPlanPriority(plan.id);
                            if (!pr) return allTicked;
                            return selectedPriorities[pr] === true;
                        });
                        if (excludeBacklog) {
                            filtered = filtered.filter(function(plan) { return !isBacklog(plan); });
                        }
                        return filtered;
                    }

                    function getPlanPriority(planId) {
                        var planPerf = planPerfMeasures.find(function(pp) { return pp.id === planId; });
                        if (!planPerf || !planPerf.measures) return '';
                        for (var i = 0; i &lt; planPerf.measures.length; i++) {
                            var m = planPerf.measures[i];
                            if (m.category &amp;&amp; m.category.toLowerCase().indexOf('priority') !== -1) {
                                return m.value || '';
                            }
                        }
                        return '';
                    }

                    function getPlanMeasures(planId) {
                        var planPerf = planPerfMeasures.find(function(pp) { return pp.id === planId; });
                        if (!planPerf || !planPerf.measures) return [];
                        return planPerf.measures;
                    }

                    function getRoadmapForPlan(planId) {
                        for (var i = 0; i &lt; allRoadmaps.length; i++) {
                            var rm = allRoadmaps[i];
                            if (rm.strategicPlans &amp;&amp; rm.strategicPlans.indexOf(planId) !== -1) {
                                return rm.name;
                            }
                        }
                        return 'Unassigned';
                    }

                    function getTechCapDependencies(plan) {
                        var deps = [];
                        if (plan.dependsOn &amp;&amp; plan.dependsOn.length &gt; 0) {
                            plan.dependsOn.forEach(function(depId) {
                                var techCap = techCapabilities.find(function(tc) { return tc.id === depId; });
                                if (techCap) {
                                    deps.push(techCap);
                                } else {
                                    var depPlan = allPlans.find(function(p) { return p.id === depId; });
                                    if (depPlan) {
                                        deps.push({ id: depId, name: depPlan.name, type: 'plan' });
                                    }
                                }
                            });
                        }
                        if (plan.planP2E &amp;&amp; plan.planP2E.length &gt; 0) {
                            plan.planP2E.forEach(function(p2e) {
                                var techCap = techCapabilities.find(function(tc) { return tc.id === p2e; });
                                if (techCap) {
                                    deps.push(techCap);
                                }
                            });
                        }
                        return deps;
                    }

                    function getProjectsForPlan(planId) {
                        return allProjects.filter(function(proj) {
                            return proj.strategicPlans &amp;&amp; proj.strategicPlans.some(function(sp) {
                                return sp.id === planId;
                            });
                        });
                    }

                    function renderView() {
                        var plans = filterPlans();
                        if (plans.length === 0) {
                            document.getElementById('roadmapArea').innerHTML = '&lt;div class="no-data"&gt;No strategic plans match the current filters.&lt;/div&gt;';
                            updateSummary(plans);
                            return;
                        }
                        var minDate = new Date(2025, 0, 1);
                        var maxDate = new Date(2032, 11, 31);
                        var totalMs = maxDate.getTime() - minDate.getTime();
                        var years = [];
                        for (var y = 2025; y &lt;= 2032; y++) {
                            years.push(y);
                        }
                        var html = '&lt;div class="timeline-header"&gt;';
                        html += '&lt;div class="timeline-label"&gt;Strategic Plan&lt;/div&gt;';
                        html += '&lt;div class="timeline-scale"&gt;';
                        years.forEach(function(yr) {
                            html += '&lt;span&gt;' + yr + '&lt;/span&gt;';
                        });
                        html += '&lt;/div&gt;&lt;/div&gt;';
                        var groupedByRoadmap = {};
                        plans.forEach(function(plan) {
                            var rmName = getRoadmapForPlan(plan.id);
                            if (!groupedByRoadmap[rmName]) groupedByRoadmap[rmName] = [];
                            groupedByRoadmap[rmName].push(plan);
                        });
                        Object.keys(groupedByRoadmap).sort().forEach(function(rmName) {
                            html += '&lt;div style="margin-top:12px;margin-bottom:6px;font-weight:700;font-size:13px;color:#5b9bd5;border-bottom:1px solid #e0e0e0;padding-bottom:4px;"&gt;' + rmName + '&lt;/div&gt;';
                            groupedByRoadmap[rmName].forEach(function(plan) {
                                var startDate = plan.validStartDate ? new Date(plan.validStartDate) : minDate;
                                var endDate = plan.validEndDate ? new Date(plan.validEndDate) : new Date(2028, 11, 31);
                                var leftPct = ((startDate.getTime() - minDate.getTime()) / totalMs) * 100;
                                var widthPct = ((endDate.getTime() - startDate.getTime()) / totalMs) * 100;
                                if (leftPct &lt; 0) leftPct = 0;
                                if (widthPct &lt; 2) widthPct = 2;
                                if (leftPct + widthPct &gt; 100) widthPct = 100 - leftPct;
                                var statusClass = 'status-' + statusKey(plan.planStatus);
                                html += '&lt;div class="plan-row"&gt;';
                                html += '&lt;div class="plan-name" title="' + plan.name + '" onclick="showPlanDetail(\'' + plan.id + '\')" style="cursor:pointer;color:#5b9bd5;"&gt;' + plan.name + '&lt;/div&gt;';
                                html += '&lt;div class="plan-bar-container"&gt;';
                                if (!plan.validStartDate) {
                                    html += '&lt;span style="font-size:11px;color:#999;font-style:italic;line-height:28px;"&gt;No current start date&lt;/span&gt;';
                                } else {
                                    html += '&lt;div class="plan-bar ' + statusClass + '" style="left:' + leftPct + '%;width:' + widthPct + '%;" onclick="showPlanDetail(\'' + plan.id + '\')" title="' + plan.name + ' (' + (plan.planStatus || '') + ')"&gt;';
                                    html += '&lt;/div&gt;';
                                }
                                html += '&lt;/div&gt;&lt;/div&gt;';
                            });
                        });
                        document.getElementById('roadmapArea').innerHTML = html;
                        updateSummary(plans);
                    }

                    function updateSummary(plans) {
                        document.getElementById('summaryTotal').textContent = plans.length;
                        STATUS_DEFS.forEach(function(d) {
                            var el = document.getElementById('summary-' + d.key);
                            if (el) el.textContent = plans.filter(function(p) { return statusKey(p.planStatus) === d.key; }).length;
                        });
                    }

                    function showPlanDetail(planId) {
                        var plan = allPlans.find(function(p) { return p.id === planId; });
                        if (!plan) return;
                        var html = '';
                        html += '&lt;h3&gt;' + plan.name + '&lt;/h3&gt;';
                        html += '&lt;div class="detail-meta"&gt;';
                        html += '&lt;div class="meta-item"&gt;&lt;div class="meta-label"&gt;Status&lt;/div&gt;&lt;div class="meta-value"&gt;' + (plan.planStatus || 'Not Set') + '&lt;/div&gt;&lt;/div&gt;';
                        html += '&lt;div class="meta-item"&gt;&lt;div class="meta-label"&gt;Roadmap&lt;/div&gt;&lt;div class="meta-value"&gt;' + getRoadmapForPlan(plan.id) + '&lt;/div&gt;&lt;/div&gt;';
                        html += '&lt;div class="meta-item"&gt;&lt;div class="meta-label"&gt;Start Date&lt;/div&gt;&lt;div class="meta-value"&gt;' + (plan.validStartDate || 'Not Set') + '&lt;/div&gt;&lt;/div&gt;';
                        html += '&lt;div class="meta-item"&gt;&lt;div class="meta-label"&gt;End Date&lt;/div&gt;&lt;div class="meta-value"&gt;' + (plan.validEndDate || 'Not Set') + '&lt;/div&gt;&lt;/div&gt;';
                        html += '&lt;/div&gt;';
                        if (plan.description) {
                            html += '&lt;div class="detail-section"&gt;&lt;h4&gt;Description&lt;/h4&gt;&lt;p&gt;' + plan.description + '&lt;/p&gt;&lt;/div&gt;';
                        }
                        // Performance Measures / Priority
                        var planPriority = getPlanPriority(planId);
                        var measures = getPlanMeasures(planId);
                        html += '&lt;div class="detail-section"&gt;&lt;h4&gt;Performance Measures&lt;/h4&gt;';
                        if (planPriority) {
                            html += '&lt;p&gt;&lt;strong&gt;Priority:&lt;/strong&gt; ' + planPriority + '&lt;/p&gt;';
                        }
                        if (measures.length &gt; 0) {
                            html += '&lt;table class="perf-table"&gt;&lt;thead&gt;&lt;tr&gt;&lt;th&gt;Category&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;th&gt;Score&lt;/th&gt;&lt;/tr&gt;&lt;/thead&gt;&lt;tbody&gt;';
                            measures.forEach(function(m) {
                                html += '&lt;tr&gt;&lt;td&gt;' + (m.category || '-') + '&lt;/td&gt;&lt;td&gt;' + (m.value || '-') + '&lt;/td&gt;&lt;td&gt;' + (m.score || '-') + '&lt;/td&gt;&lt;/tr&gt;';
                            });
                            html += '&lt;/tbody&gt;&lt;/table&gt;';
                        } else {
                            html += '&lt;p style="color:#999;"&gt;No performance measures found for this plan.&lt;/p&gt;';
                        }
                        html += '&lt;/div&gt;';
                        var planProjects = getProjectsForPlan(planId);
                        html += '&lt;div class="detail-section"&gt;&lt;h4&gt;Associated Projects (' + planProjects.length + ')&lt;/h4&gt;';
                        if (planProjects.length &gt; 0) {
                            html += '&lt;table class="perf-table"&gt;&lt;thead&gt;&lt;tr&gt;&lt;th&gt;Project&lt;/th&gt;&lt;th&gt;Priority&lt;/th&gt;&lt;th&gt;Status&lt;/th&gt;&lt;th&gt;Start&lt;/th&gt;&lt;th&gt;End&lt;/th&gt;&lt;/tr&gt;&lt;/thead&gt;&lt;tbody&gt;';
                            planProjects.forEach(function(proj) {
                                html += '&lt;tr&gt;';
                                html += '&lt;td&gt;' + proj.name + '&lt;/td&gt;';
                                html += '&lt;td&gt;' + (proj.priority || '-') + '&lt;/td&gt;';
                                html += '&lt;td&gt;' + (proj.lifecycleStatus || '-') + '&lt;/td&gt;';
                                html += '&lt;td&gt;' + (proj.proposedStartDate || proj.actualStartDate || '-') + '&lt;/td&gt;';
                                html += '&lt;td&gt;' + (proj.targetEndDate || proj.forecastEndDate || '-') + '&lt;/td&gt;';
                                html += '&lt;/tr&gt;';
                            });
                            html += '&lt;/tbody&gt;&lt;/table&gt;';
                        } else {
                            html += '&lt;p style="color:#999;"&gt;No projects linked to this plan.&lt;/p&gt;';
                        }
                        html += '&lt;/div&gt;';
                        if (plan.objectives &amp;&amp; plan.objectives.length &gt; 0) {
                            html += '&lt;div class="detail-section"&gt;&lt;h4&gt;Objectives&lt;/h4&gt;&lt;ul&gt;';
                            plan.objectives.forEach(function(obj) {
                                html += '&lt;li&gt;' + (obj.name || obj) + '&lt;/li&gt;';
                            });
                            html += '&lt;/ul&gt;&lt;/div&gt;';
                        }
                        if (plan.drivers &amp;&amp; plan.drivers.length &gt; 0) {
                            html += '&lt;div class="detail-section"&gt;&lt;h4&gt;Drivers&lt;/h4&gt;&lt;ul&gt;';
                            plan.drivers.forEach(function(d) {
                                html += '&lt;li&gt;' + (d.name || d) + '&lt;/li&gt;';
                            });
                            html += '&lt;/ul&gt;&lt;/div&gt;';
                        }
                        var techDeps = getTechCapDependencies(plan);
                        html += '&lt;div class="detail-section"&gt;&lt;h4&gt;Technology Capability Dependencies (' + techDeps.length + ')&lt;/h4&gt;';
                        if (techDeps.length &gt; 0) {
                            html += '&lt;ul class="dep-list"&gt;';
                            techDeps.forEach(function(dep) {
                                var icon = dep.type === 'plan' ? '[Plan]' : '&#x2699;';
                                html += '&lt;li&gt;' + icon + ' ' + dep.name;
                                if (dep.domain) html += ' &lt;span style="color:#888;font-size:11px;"&gt;(' + dep.domain + ')&lt;/span&gt;';
                                html += '&lt;/li&gt;';
                            });
                            html += '&lt;/ul&gt;';
                        } else {
                            html += '&lt;p style="color:#999;"&gt;No technology capability dependencies recorded.&lt;/p&gt;';
                        }
                        html += '&lt;/div&gt;';
                        document.getElementById('detailContent').innerHTML = html;
                        document.getElementById('detailPanel').classList.add('open');
                        document.getElementById('overlay').classList.add('open');
                    }

                    function closePlanDetail() {
                        document.getElementById('detailPanel').classList.remove('open');
                        document.getElementById('overlay').classList.remove('open');
                    }
                </script>
            </head>
            <body>
                <xsl:call-template name="Heading"/>
                <xsl:call-template name="ViewUserScopingUI"/>
                <div class="view-wrapper">
                    <h1 style="margin-bottom:5px;">Explore UCL's Digital Strategic Plan</h1>
                    <p style="color:#666;margin-bottom:20px;">Explore strategic plans on a timeline, filter by roadmap and priority, and drill into plan details including technology capability dependencies.</p>
                    <div class="summary-cards">
                        <div class="summary-card"><div class="count" id="summaryTotal">0</div><div class="label">Total Plans</div></div>
                        <div class="summary-card"><div class="count" id="summary-backlog" style="color:#8E9BAE;">0</div><div class="label">Backlog</div></div>
                        <div class="summary-card"><div class="count" id="summary-idea" style="color:#5b9bd5;">0</div><div class="label">Roadmap Idea</div></div>
                        <div class="summary-card"><div class="count" id="summary-discovery" style="color:#ed7d31;">0</div><div class="label">Discovery</div></div>
                        <div class="summary-card"><div class="count" id="summary-governance" style="color:#9b59b6;">0</div><div class="label">Governance</div></div>
                        <div class="summary-card"><div class="count" id="summary-inprogress" style="color:#70ad47;">0</div><div class="label">In Progress</div></div>
                        <div class="summary-card"><div class="count" id="summary-done" style="color:#2E7D32;">0</div><div class="label">Done</div></div>
                    </div>
                    <div class="filters-bar">
                        <div><label for="filterRoadmap">Roadmap:</label><select id="filterRoadmap"><option value="all">All Roadmaps</option></select></div>
                        <div class="priority-group">
                            <label>Priority:</label>
                            <div class="priority-checks" id="priorityChecks"></div>
                            <span class="pr-actions"><a onclick="priorityAll()">All</a><a onclick="priorityNone()">None</a></span>
                        </div>
                        <div><label class="toggle-label"><input type="checkbox" id="excludeBacklog"/><xsl:text> </xsl:text>Exclude Backlog</label></div>
                    </div>
                    <div class="legend">
                        <div class="legend-item"><div class="legend-swatch" style="background:#8E9BAE;"/><xsl:text> </xsl:text>Backlog</div>
                        <div class="legend-item"><div class="legend-swatch" style="background:#5b9bd5;"/><xsl:text> </xsl:text>Roadmap Idea</div>
                        <div class="legend-item"><div class="legend-swatch" style="background:#ed7d31;"/><xsl:text> </xsl:text>Discovery</div>
                        <div class="legend-item"><div class="legend-swatch" style="background:#9b59b6;"/><xsl:text> </xsl:text>Governance</div>
                        <div class="legend-item"><div class="legend-swatch" style="background:#70ad47;"/><xsl:text> </xsl:text>In Progress</div>
                        <div class="legend-item"><div class="legend-swatch" style="background:#2E7D32;"/><xsl:text> </xsl:text>Done</div>
                        <div class="legend-item"><div class="legend-swatch" style="background:#bdc3c7;"/><xsl:text> </xsl:text>Not Set</div>
                    </div>
                    <div class="roadmap-container" id="mainContent">
                        <div id="roadmapArea"><p>Loading strategic plans...</p></div>
                    </div>
                </div>
                <div class="overlay" id="overlay" onclick="closePlanDetail()"/>
                <div class="detail-panel" id="detailPanel">
                    <button class="close-btn" onclick="closePlanDetail()">x</button>
                    <div id="detailContent"/>
                </div>
                <xsl:call-template name="Footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
