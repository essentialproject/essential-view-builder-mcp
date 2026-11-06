<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/core_api_fetcher.xsl"/>

    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
    <xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
 
	<xsl:variable name="linkClasses" select="('Project', 'Enterprise_Strategic_Plan','Business_Objective','Application_Architecture_Objective', 'Technology_Architecture_Objective','Information_Architecture_Objective')"/>
	<xsl:variable name="businessObjectives" select="node()/simple_instance[type = ('Business_Objective','Application_Architecture_Objective', 'Technology_Architecture_Objective','Information_Architecture_Objective')]"/>
    <xsl:key name="objectivesToQuality" match="simple_instance[type = 'OBJ_TO_SVC_QUALITY_RELATION']" use="name"/>
    <xsl:key name="busServQuality" match="simple_instance[type = 'Business_Service_Quality']" use="name"/>
   
    <xsl:variable name="businessModels" select="node()/simple_instance[type = 'Business_Model'][count(own_slot_value[slot_reference='bm_business_goals_objectives']/value)!=0]"/>
    <xsl:variable name="strategicPlans" select="node()/simple_instance[type = 'Enterprise_Strategic_Plan']"/>
    <xsl:template match="knowledge_base">
        <xsl:call-template name="docType"/>
        <html lang="en">
            <head>
                <xsl:call-template name="commonHeadContent"/>
                <xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
                <title>Strategic Roadmap - Supporting our University</title>
                <script src="js/pptxgenjs/dist/pptxgen.bundle.js"></script>
                <style>
                    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap');

                    * { box-sizing: border-box; }
                    :root {
                        --primary-blue: #003366;
                        --accent-orange: #FF6B35;
                        --accent-yellow: #F7B731;
                        --accent-teal: #00A8A8;
                        --accent-cyan: #00D4FF;
                        --accent-purple: #6C5CE7;
                        --accent-green: #00B894;
                        --bg-primary: #FAFBFC;
                        --bg-secondary: #FFFFFF;
                        --text-primary: #1A1A2E;
                        --text-secondary: #4A5568;
                        --border-color: #E2E8F0;
                        --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.05);
                        --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08);
                        --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.12);
                        --shadow-xl: 0 12px 40px rgba(0, 0, 0, 0.15);
                        --spacing-xs: 0.25rem;
                        --spacing-sm: 0.4rem;
                        --spacing-md: 0.6rem;
                        --spacing-lg: 0.8rem;
                        --spacing-xl: 1rem;
                        --radius-sm: 4px;
                        --radius-md: 6px;
                        --radius-lg: 8px;
                        --transition-fast: 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                        --transition-base: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        --transition-slow: 0.5s cubic-bezier(0.4, 0, 0.2, 1);

                        /* Objective Color Palette */
                        --obj-color-1: #FF6B35; /* Orange */
                        --obj-color-2: #00A8A8; /* Teal */
                        --obj-color-3: #6C5CE7; /* Purple */
                        --obj-color-4: #F7B731; /* Yellow */
                        --obj-color-5: #00D4FF; /* Cyan */
                        --obj-color-6: #00B894; /* Green */
                        --obj-color-7: #A8E063; /* Lime */
                        --obj-color-8: #EB3349; /* Red */
                    }

                    * { margin: 0; padding: 0; box-sizing: border-box; }

                    body {
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
                        color: var(--text-primary);
                        line-height: 1.4;
                        padding: 0; 
                        margin: 0;
                        min-height: 100vh;
                        font-size: 1rem;
                    }

                    /* Skip Navigation Link - WCAG 2.4.1 */
                    .skip-link {
                        position: absolute;
                        top: -40px;
                        left: 0;
                        background: var(--primary-blue);
                        color: white;
                        padding: 8px 16px;
                        text-decoration: none;
                        font-weight: 600;
                        z-index: 10000;
                        border-radius: 0 0 4px 0;
                    }
                    .skip-link:focus {
                        top: 0;
                        outline: 3px solid var(--accent-orange);
                        outline-offset: 2px;
                    }

                    /* Screen reader only text - WCAG best practice */
                    .sr-only {
                        position: absolute;
                        width: 1px;
                        height: 1px;
                        padding: 0;
                        margin: -1px;
                        overflow: hidden;
                        clip: rect(0, 0, 0, 0);
                        white-space: nowrap;
                        border-width: 0;
                    }

                    .container {
                        width: 100%;
                        max-width: 100%;
                        margin: 0;
                        background: var(--bg-secondary);
                        padding: var(--spacing-md);
                        animation: fadeIn 0.6s ease-out;
                    }

                    .roadmap-wrapper {
                        width: 100%;
                        max-width: 100%;
                        overflow-x: auto;
                        overflow-y: auto;
                        max-height: calc(100vh - 160px);
                        padding-bottom: 20px;
                        margin-top: var(--spacing-lg);
                        -webkit-overflow-scrolling: touch;
                        border: 1px solid var(--border-color);
                        border-radius: var(--radius-md);
                        background: white;
                        position: relative;
                    }

                    @keyframes fadeIn {
                        from { opacity: 0; transform: translateY(20px); }
                        to { opacity: 1; transform: translateY(0); }
                    }

                    .roadmap-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: var(--spacing-xl);
                        padding-bottom: var(--spacing-lg);
                        border-bottom: 3px solid var(--primary-blue);
                        position: relative;
                    }

                    .roadmap-header::after {
                        content: '';
                        position: absolute;
                        bottom: -3px;
                        left: 0;
                        width: 200px;
                        height: 3px;
                        background: linear-gradient(90deg, var(--accent-orange), var(--accent-yellow));
                        animation: slideIn 0.8s ease-out;
                    }

                    @keyframes slideIn { from { width: 0; } to { width: 200px; } }

                    .roadmap-header h1 {
                        font-size: 2.5rem;
                        font-weight: 800;
                        color: var(--primary-blue);
                        letter-spacing: -0.5px;
                    }

                    .version-badge {
                        background: linear-gradient(135deg, var(--accent-yellow), #FFD93D);
                        color: var(--primary-blue);
                        padding: var(--spacing-xs) var(--spacing-md);
                        border-radius: var(--radius-md);
                        font-weight: 700;
                        font-size: 0.9rem;
                        box-shadow: var(--shadow-md);
                        transition: transform var(--transition-base);
                        height: fit-content;
                        white-space: nowrap;
                    }

                    .version-badge:hover { transform: rotate(0deg) scale(1.05); }

                    .roadmap-jump-toggle {
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        padding: 4px;
                        border-radius: 999px;
                        background: #eef3f8;
                        border: 1px solid #d6e0ea;
                    }
                    .jump-btn {
                        border: none;
                        background: transparent;
                        color: var(--primary-blue);
                        font-weight: 700;
                        font-size: 0.85rem;
                        padding: 6px 12px;
                        border-radius: 999px;
                        cursor: pointer;
                        transition: background var(--transition-fast), color var(--transition-fast);
                    }
                    .jump-btn:hover {
                        background: #dfe8f2;
                    }
                    .jump-btn.active {
                        background: var(--primary-blue);
                        color: #fff;
                        box-shadow: var(--shadow-sm);
                    }

                    .export-pptx-btn {
                        background: var(--accent-orange);
                        color: white !important;
                        border: none;
                        padding: 8px 20px;
                        border-radius: 999px;
                        font-weight: 700;
                        font-size: 0.9rem;
                        cursor: pointer;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all var(--transition-base);
                        box-shadow: var(--shadow-md);
                        margin-left: var(--spacing-md);
                        text-decoration: none;
                    }

                    .export-pptx-btn:hover {
                        background: #e65a2b;
                        transform: translateY(-2px);
                        box-shadow: var(--shadow-lg);
                    }

                    .export-pptx-btn i {
                        font-size: 1.1rem;
                    }

                    .roadmap-header-row h2  { color: #ffffff; }

                    .timeline-header-cell { 
                        display: flex; 
                        flex-direction: column; 
                        position: sticky;
                        top: var(--roadmap-sticky-top, 0px);
                        z-index: 200;
                        background: white;
                        pointer-events: none;
                    }
                    .timeline-header-cell .timeline-nav-arrow,
                    .timeline-header-cell .section-title {
                        pointer-events: auto;
                    }

                    .roadmap-rows {
                        display: grid;
                        grid-template-columns: 200px 300px 1fr; 
                        gap: var(--spacing-sm);
                        row-gap: 2px;
                        padding: 0;
                        width: 100%; 
                    }

                    .section-title {
                        font-size: 1rem;
                        font-weight: 700;
                        color: var(--bg-secondary);
                        background: var(--primary-blue);
                        padding: var(--spacing-sm) var(--spacing-md);
                        border-radius: var(--radius-sm);
                        text-align: center;
                        text-transform: uppercase;
                        letter-spacing: 0.75px;
                        box-shadow: var(--shadow-sm);
                        min-height: 48px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        position: sticky;
                        top: var(--roadmap-sticky-top, 0px);
                        z-index: 201;
                        pointer-events: none;
                    }

                    .timeline-years {
                        display: grid;
                        grid-template-columns: repeat(var(--timeline-years, 4), 1fr); 
                        background: #f8f9fa;
                        border-bottom: 1px solid #dee2e6;
                        font-size: 0.9rem;
                        font-weight: 700;
                        color: #495057;
                        position: sticky;
                        top: calc(var(--roadmap-sticky-top, 0px) + var(--roadmap-header-row-height, 48px));
                        z-index: 150;
                        width: 100%; 
                        pointer-events: none;
                    }
                    .header-spacer {
                        background: #f8f9fa;
                        border-bottom: 1px solid #dee2e6;
                        position: sticky;
                        top: calc(var(--roadmap-sticky-top, 0px) + var(--roadmap-header-row-height, 48px));
                        z-index: 149;
                        pointer-events: none;
                    }

                    .timeline-year {
                        font-weight: 700;
                        color: var(--primary-blue);
                        font-size: 1.1rem;
                        text-align: center;
                        padding: 12px 6px;
                        white-space: nowrap; /* Absolutely no wrapping */
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .timeline-nav-arrow {
                        background: none;
                        border: none;
                        color: white;
                        cursor: pointer;
                        padding: 0 8px;
                        font-size: 1.4rem;
                        transition: transform 0.2s;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }
                    .timeline-nav-arrow:hover { transform: scale(1.2); color: var(--accent-orange); }
                    .timeline-nav-arrow:focus { outline: none; color: var(--accent-orange); }

                    .timeline-header-container {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        background: var(--primary-blue);
                        border-radius: var(--radius-sm);
                        margin-bottom: var(--spacing-sm);
                    }
                    .timeline-header-container .section-title {
                        margin-bottom: 0;
                        box-shadow: none;
                        background: transparent;
                    }

                    .objective-cell {
                        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                        border-left: 5px solid var(--obj-color, var(--accent-orange));
                        padding: var(--spacing-lg);
                        border-radius: var(--radius-sm);
                        box-shadow: var(--shadow-sm);
                        display: flex;
                        flex-direction: column;
                        justify-content: flex-start;
                        font-size: 1.2rem;
                        line-height: 1.4;
                        transition: all var(--transition-base);
                        cursor: pointer;
                        min-height: 48px;
                    }

                    .objective-cell { grid-column: 1; }
                    .objective-cell.spanning { grid-row: span var(--row-span, 1); }
                    .objective-cell:hover { transform: translateX(2px); box-shadow: var(--shadow-md); }
                    .objective-cell-header { display: flex; flex-direction: column; gap: 4px; margin-bottom: var(--spacing-sm); }
                    .objective-context { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 4px; }
                    .context-tag { font-size: 0.85rem; font-weight: 600; padding: 2px 8px; border-radius: 4px; background: rgba(0, 102, 204, 0.1); color: var(--primary-blue); }
                    .context-tag.goal { background: rgba(0, 168, 168, 0.1); color: var(--accent-teal); }
                    
                    .objective-title-wrapper { display: flex; align-items: center; gap: var(--spacing-sm); }
                    .objective-cell-title { font-weight: 700; color: var(--primary-blue); font-size: 1.25rem; margin-bottom: 0; }
                    .objective-cell-icon { font-size: 1.6rem; display: flex; align-items: center; justify-content: center; }
                    .objective-cell-items { list-style: none; margin-top: var(--spacing-xs); padding-left: 0; }
                    .objective-cell-items li { font-size: 1.2rem; color: var(--text-secondary); padding-left: 1.2rem; margin-bottom: 6px; position: relative; line-height: 1.4; }
                    .objective-cell-items li::before { content: '•'; position: absolute; left: 0; color: var(--accent-orange); }

                    .capability-cell { 
                        grid-column: 2; 
                        background: #f1f4f8; 
                        padding: var(--spacing-md);
                        border-radius: var(--radius-sm);
                        border-left: 3px solid var(--accent-teal);
                        display: flex;
                        align-items: flex-start;
                        font-weight: 500;
                    }
                    .capability-cell.spanning { grid-row: span var(--row-span, 1); }
                    .capability-cell:hover { border-color: var(--accent-teal); background: #e8f0f8; transform: translateX(2px); }
                    .capability-cell::before { content: '▸'; margin-right: var(--spacing-xs); color: var(--accent-teal); font-weight: bold; font-size: 1.2rem; }
                    
                    .action-cell { grid-column: 3; border-left: 0px solid var(--obj-color, var(--accent-purple)); }
                    .action-cell.spanning { grid-row: span var(--row-span, 1); }
                    .action-cell:hover { opacity: 0.9; background: linear-gradient(135deg, #ffffff 0%, rgba(108, 92, 231, 0.05) 100%); transform: scale(1.01); }
                    // .action-cell::before { content: '•'; margin-right: var(--spacing-xs); color: var(--obj-color, var(--accent-purple)); font-weight: bold; font-size: 1.4rem; }

                    .timeline-cell { 
                        grid-column: 3; 
                        display: grid; 
                        grid-template-columns: repeat(var(--timeline-years, 4), 180px); 
                        gap: 1px; 
                        min-height: 24px; 
                    }
                    .timeline-cell.spanning-objective { grid-row: span var(--row-span, 1); align-items: stretch; }

                    .capability-cell.empty, .action-cell.empty { background: transparent; border: none; cursor: default; }
                    .capability-cell.empty::before, .action-cell.empty::before { display: none; }

                    .timeline-bar-container {
                        width: 100%;
                        height: 100%;
                        position: relative;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .timeline-bar {
                        width: 100%;
                        height: 100%;
                        min-height: 36px;
                        border-radius: var(--radius-sm);
                        padding: 4px var(--spacing-sm);
                        font-size: 1.1rem;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        text-align: center;
                        box-shadow: var(--shadow-sm);
                        transition: all var(--transition-base);
                        cursor: pointer;
                        position: relative;
                        overflow: hidden;

                        /* Default gradient (category rules may override) */
                        background: linear-gradient(135deg, var(--obj-color, #d45a2a), var(--obj-color-alt, #e09920));
                        color: white !important;
                        border: 2px solid transparent;

                        /* Fade-in on load */
                        opacity: 0;
                        transform: translateY(6px);
                        animation: timelineBarFadeIn 0.55s ease-out forwards;
                    }

                    /* Solid colour overlay that fades in AFTER the bar fades in */
                    .timeline-bar::after {
                        content: '';
                        position: absolute;
                        inset: 0;
                        background: var(--bar-solid, var(--obj-color, #d45a2a));
                        opacity: 0;
                        z-index: 0;
                        animation: timelineBarSolidify 0.25s ease-out forwards;
                        animation-delay: 0.55s;
                        pointer-events: none;
                    }

                    .timeline-bar::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: -100%;
                        width: 100%;
                        height: 100%;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                        transition: left 0.5s ease;
                        z-index: 1;
                        pointer-events: none;
                    }

                    /* Reduced motion support - WCAG 2.3.3 */
                    @media (prefers-reduced-motion: reduce) {
                        .timeline-bar::before { transition: none; }
                        .timeline-bar:hover::before { display: none; }
                    }

                    .timeline-bar:hover::before { left: 100%; }
                    .timeline-bar:hover { transform: translateY(-1px); box-shadow: var(--shadow-md); filter: brightness(1.1); }
                    .timeline-bar-title { 
                        position: relative; 
                        z-index: 2; 
                        line-height: 1.2; 
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        padding: 0 4px;
                        width: 100%;
                    }

                   

                    /* Hidden source for popover content - keeps it out of the grid layout */
                    .popover-content-source { display: none; }
                    .popover-title-source { display: none; }

                    /* Popover Content Styling */
                    .popover-content .popover-dates {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 10px;
                        align-items: baseline;
                        margin-bottom: 8px;
                        border-bottom: 1px solid #eee;
                        padding-bottom: 6px;
                    }
                    .popover-content .popover-date-block {
                        display: inline-flex;
                        gap: 6px;
                        align-items: baseline;
                    }
                    .popover-content .popover-date-label {
                        font-weight: 700;
                        color: var(--text-secondary);
                        letter-spacing: 0.2px;
                    }
                    .popover-content .popover-date-value {
                        font-weight: 800;
                        color: #d45a2a;
                    }
                    .popover-content .popover-projects { padding-left: 0; list-style: none; margin: 0; }
                    .popover-content .project-item { padding: 4px 0; border-bottom: 1px solid #f9f9f9; }
                    .popover-content .project-name { font-weight: 600; font-size: 0.9em; }
                    .popover-content .project-dates { color: #666; font-size: 0.85em; }
                    .projects-lozenge{border-radius: 6px; background-color: #d45a2a; color: white; padding: 3px}
                    .popover { z-index: 3000; }
        
                    @keyframes timelineBarFadeIn {
                        from { opacity: 0; transform: translateY(6px); }
                        to { opacity: 1; transform: translateY(0); }
                    }

                    @keyframes timelineBarSolidify {
                        from { opacity: 0; }
                        to { opacity: 1; }
                    }

                    .bottom-sections {
                        display: grid;
                        grid-template-columns: repeat(1, 1fr);
                        gap: var(--spacing-lg);
                        margin-top: var(--spacing-xl);
                        padding-top: var(--spacing-xl);
                        border-top: 2px solid var(--border-color);
                        width: 100%;
                    }

                    .enabling-section-outer {
                        grid-column: 1 / -1;
                        width: 100%;
                        margin-bottom: var(--spacing-xl);
                    }

                    .bottom-section-title {
                        grid-column: 1 / -1;
                        font-size: 1.2rem;
                        font-weight: 700;
                        color: var(--primary-blue);
                        margin-top: var(--spacing-xl);
                        margin-bottom: var(--spacing-lg);
                        padding-bottom: var(--spacing-sm);
                        border-bottom: 3px solid var(--accent-orange);
                    }

                    .enabling-container { display: flex; flex-direction: column; gap: var(--spacing-sm); }
                    .enabling-item {
                        display: flex;
                        align-items: flex-start;
                        gap: var(--spacing-sm);
                        font-size: 1.15rem;
                        padding: var(--spacing-md);
                        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                        border-radius: var(--radius-sm);
                        transition: all var(--transition-fast);
                    }

                    .enabling-item:hover { background: linear-gradient(135deg, #ffffff 0%, #e8f5f5 100%); transform: translateX(4px); }
                    .enabling-bullet { color: var(--accent-orange); font-weight: bold; font-size: 1.3rem; }
                    .enabling-text { flex: 1; color: var(--text-secondary); }
                    .enabling-description { color: var(--text-primary); font-weight: 500; }

                    .dependencies-list, .metrics-list { display: flex; flex-direction: column; gap: var(--spacing-sm); }
                    .dependency-item, .metric-item {
                        font-size: 1.15rem;
                        padding: var(--spacing-md);
                        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                        border-left: 5px solid var(--accent-teal);
                        border-radius: var(--radius-sm);
                        color: var(--text-secondary);
                        transition: all var(--transition-fast);
                    }

                    .dependency-item:hover, .metric-item:hover { transform: translateX(4px); border-left-width: 5px; box-shadow: var(--shadow-sm); }
                    .risks-indicators { display: flex; gap: var(--spacing-md); justify-content: center; align-items: center; }
                    .risk-indicator { width: 20px; height: 20px; border-radius: 50%; box-shadow: var(--shadow-md); transition: all var(--transition-base); cursor: pointer; }
                    .risk-indicator:hover { transform: scale(1.3); box-shadow: var(--shadow-lg); }
 
                    .header-controls { display: flex; align-items: center; gap: var(--spacing-md); }
                    .bm-selector-container { display: flex; align-items: center; gap: var(--spacing-sm); background: rgba(0,0,0,0.1); padding: 4px 12px; border-radius: var(--radius-md); border: 1px solid rgba(255,255,255,0.2); }
                    .bm-selector-container label { font-size: 1.2rem; color: rgba(0,0,0,0.8); font-weight: 500; }
                    .bm-select { background: transparent; border: none; color: black; font-family: inherit; font-size: 1.4rem; font-weight: 600; cursor: pointer; outline: none; padding-right: 20px; }
                    .bm-select option { background: var(--primary-blue); color: white; }

                    .tooltip { position: relative; cursor: help; }
                    .tooltip::after {
                        content: attr(data-tooltip);
                        position: absolute;
                        bottom: calc(100% + 8px);
                        left: 0;
                        background: rgba(30, 41, 59, 0.95);
                        color: white;
                        padding: 8px 12px;
                        border-radius: 6px;
                        font-size: 1.1rem;
                        white-space: normal;
                        width: max-content;
                        max-width: 250px;
                        line-height: 1.4;
                        text-align: left;
                        opacity: 0;
                        pointer-events: none;
                        transition: all 0.2s ease;
                        z-index: 1000;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    }
                    .tooltip::before {
                        content: '';
                        position: absolute;
                        bottom: calc(100% + 3px);
                        left: 15px;
                        border: 5px solid transparent;
                        border-top-color: rgba(30, 41, 59, 0.95);
                        opacity: 0;
                        pointer-events: none;
                        transition: all 0.2s ease;
                        z-index: 1000;
                    }
                    .tooltip:hover::after, .tooltip:hover::before { opacity: 1; transform: translateY(-2px); }

                    /* Keyboard Focus States - WCAG 2.4.7 Enhanced */
                    .objective-cell:focus-visible,
                    .capability-cell:focus-visible,
                    .action-cell:focus-visible,
                    .timeline-bar:focus-visible,
                    .bm-select:focus-visible {
                        outline: 3px solid #0066cc;
                        outline-offset: 3px;
                        box-shadow: 0 0 0 6px rgba(0, 102, 204, 0.25);
                    }
                    .skip-link:focus {
                        outline: 3px solid var(--accent-orange);
                        outline-offset: 2px;
                    }
                     /* Reduced motion for all animations - WCAG 2.3.3 */
                    @media (prefers-reduced-motion: reduce) {
                        *,
                        *::before,
                        *::after {
                            animation-duration: 0.01ms !important;
                            animation-iteration-count: 1 !important;
                            transition-duration: 0.01ms !important;
                        }
                        .timeline-bar { opacity: 1 !important; transform: none !important; animation: none !important; }
                        .timeline-bar::after { opacity: 1 !important; animation: none !important; }
                    }
                </style>
            </head>
            <body>
                <!-- Skip Navigation Link - WCAG 2.4.1 -->
                <a href="#mainContent" class="skip-link">Skip to main content</a>
                
                <xsl:call-template name="Heading"/>
                <div class="container" id="mainContent" role="main" aria-labelledby="mainTitle">
                    <header class="roadmap-header">
                        <h1 id="mainTitle"><span id="mainTitleText"></span> <span id="BMName"></span></h1>
                        <div class="header-controls">
                            <!--
                            <div class="version-badge" id="versionBadge" role="status" aria-live="polite">V 0.4</div>
                        -->
                            <div class="bm-selector-container">
                                <label for="bm-selector"><b>Business Model:</b></label>
                                <select id="bm-selector" class="bm-select" aria-describedby="bm-selector-help">
                                    <option value="all">Show All</option>
                                </select>
                                <span id="bm-selector-help" class="sr-only">Filter the roadmap by selecting a specific business model or view all</span>
                            </div>
                            <div class="roadmap-jump-toggle" role="group" aria-label="Jump to section">
                                <button type="button" class="jump-btn" data-jump="roadmapRows">Roadmap</button>
                                <button type="button" class="jump-btn" data-jump="enablingSection">Enabling</button>
                            </div>
                            <button type="button" class="export-pptx-btn" onclick="exportToPPTX()" id="exportPptxBtn">
                                <i class="fa fa-file-powerpoint-o"></i> Export to PPTX
                            </button>
                        </div>
                    </header>


                    <div class="roadmap-wrapper">
                        <div id="roadmapRows" class="roadmap-rows" role="table" aria-label="Roadmap Content"></div>

                        <div class="bottom-section-title">
                            <h4>KPIs</h4>
                        </div>
                        <div class="bottom-sections">
                            <!--    <div class="dependencies-section">
                                    <h3 class="bottom-section-title" id="dependenciesTitle"></h3>
                                    <div id="dependenciesContainer" class="dependencies-list"></div>
                                </div>
                            -->
                            <div class="metrics-section"> 
                                <div id="metricsContainer" class="metrics-list"></div>
                            </div>
                            <!--
                                <div class="risks-section">
                                    <h3 class="bottom-section-title">Risks</h3>
                                    <div id="risksContainer" class="risks-indicators"></div>
                                </div>
                            -->
                        </div>
                    </div>
                </div>

                <!-- Handlebars Templates -->
                <script id="roadmap-template" type="text/x-handlebars-template">
                    <h2 class="section-title" id="objectivesTitle" role="columnheader" style="grid-column: 1; grid-row: 1;">Strategic Goals</h2>
                    <h2 class="section-title" id="capabilitiesTitle" role="columnheader" style="grid-column: 2; grid-row: 1;">Strategic Objectives</h2>
                    <div class="timeline-header-cell" role="columnheader" style="grid-column: 3; grid-row: 1;">
                        <div class="timeline-header-container">
                            <div style="display: flex; align-items: center;">
                                <button class="timeline-nav-arrow" id="btn-start-down" aria-label="Decrease Start Year"><i class="fa fa-chevron-left"></i></button>
                                <button class="timeline-nav-arrow" id="btn-start-up" aria-label="Increase Start Year"><i class="fa fa-chevron-right"></i></button>
                            </div>
                            <h2 class="section-title" id="timelineTitle" style="box-shadow: none;">Strategic Roadmap</h2>
                            <div style="display: flex; align-items: center;">
                                <button class="timeline-nav-arrow" id="btn-end-down" aria-label="Decrease End Year"><i class="fa fa-chevron-left"></i></button>
                                <button class="timeline-nav-arrow" id="btn-end-up" aria-label="Increase End Year"><i class="fa fa-chevron-right"></i></button>
                            </div>
                        </div>
                    </div>

                    <!-- Years Row -->
                    <div class="timeline-years" role="columnheader">
                        <xsl:attribute name="style">grid-column: 3 / 4; grid-row: 2; --timeline-years: {{timelineYearsCount}}</xsl:attribute>
                        {{#each years}}
                            <div class="timeline-year">{{label}}</div>
                        {{/each}}
                    </div>
                    <div class="header-spacer" aria-hidden="true" role="presentation">
                        <xsl:attribute name="style">grid-column: 1; grid-row: 2;</xsl:attribute>
                    </div>
                    <div class="header-spacer" aria-hidden="true" role="presentation">
                        <xsl:attribute name="style">grid-column: 2; grid-row: 2;</xsl:attribute>
                    </div>

                    {{#each goals}}
                        <div role="gridcell" class="objective-cell spanning">
                            <xsl:attribute name="aria-label">Goal: {{name}}</xsl:attribute>
                            <xsl:attribute name="tabindex">0</xsl:attribute>
                            <xsl:attribute name="style">grid-row: span {{span}}; --obj-color: {{color}}; --obj-color-alt: {{colorAlt}}</xsl:attribute>
                            <div class="objective-cell-header">
                                <div class="objective-title-wrapper">
                                    <div class="objective-cell-title"> {{{essRenderInstanceMenuLink this}}}</div>
                                </div>
                            </div>
                        </div>

                        {{#each objectives}}
                            <div role="gridcell" class="capability-cell spanning popover-trigger">
                                <xsl:attribute name="aria-label">Objective: {{name}}. Press Enter or Space for details.</xsl:attribute>
                                <xsl:attribute name="tabindex">0</xsl:attribute>
                                <xsl:attribute name="data-toggle">popover</xsl:attribute>
                                <xsl:attribute name="data-popover-id">pop-{{#if popoverId}}{{popoverId}}{{else}}{{id}}{{/if}}</xsl:attribute>
                                <xsl:attribute name="style">grid-row: span {{span}}</xsl:attribute>
                                {{this.name}}
                            </div>
                            <div class="popover-content-source">
                                <xsl:attribute name="id">pop-{{#if popoverId}}{{popoverId}}{{else}}{{id}}{{/if}}</xsl:attribute>
                                <div class="popover-description">
                                    {{#if description}}{{description}}{{else}}No description set{{/if}}
                                </div>
                            </div>
                            <div class="popover-title-source">
                                <xsl:attribute name="id">pop-title-{{#if popoverId}}{{popoverId}}{{else}}{{id}}{{/if}}</xsl:attribute>
                                {{{essRenderInstanceMenuLink this}}}
                            </div>

                            <div role="gridcell" class="timeline-cell spanning-plan">
                                <xsl:attribute name="style">grid-row: span {{span}}; --obj-color: {{../color}}; --obj-color-alt: {{../colorAlt}}; --timeline-years: {{../../timelineYearsCount}}; display: grid; grid-template-rows: repeat({{span}}, minmax(36px, auto)); grid-template-columns: repeat({{../../timelineYearsCount}}, 1fr); gap: 1px;</xsl:attribute>
                                {{#each plans}}
                                    {{#each timelineBars}}
                                    <div class="timeline-bar-container">
                                        <xsl:attribute name="style">grid-column: {{startIndex}} / {{endIndex}}; grid-row: calc({{../rowOffset}} + {{laneOffset}} - 1);</xsl:attribute>
                                        
                                        <div class="timeline-bar {{category}} popover-trigger">
                                            <xsl:attribute name="role">button</xsl:attribute>
                                            <xsl:attribute name="aria-label">{{../../name}}: {{title}} from {{startDate}} to {{endDate}}. Press Enter or Space for details, Escape to close.</xsl:attribute>
                                            <xsl:attribute name="tabindex">0</xsl:attribute>
                                            <xsl:attribute name="data-toggle">popover</xsl:attribute>
                                            <xsl:attribute name="data-popover-id">pop-{{../popoverId}}</xsl:attribute>
                                            
                                            <div class="timeline-bar-title">
                                                {{title}}
                                                   {{#if startDate}}{{else}} <i class="fa fa-warning" style="color:#d21212"></i> {{/if}}
                                            </div>
                                        </div>
                                    </div>
                                    {{/each}}

                                    <div class="popover-content-source">
                                        <xsl:attribute name="id">pop-{{popoverId}}</xsl:attribute>
                                       
                                        <div class="popover-dates">
                                          <span class="popover-date-block">
                                            <span class="popover-date-label">Start:</span>
                                            <span class="popover-date-value">{{#if startDate}}{{startDate}}{{else}}No Date Set{{/if}}</span>
                                          </span>
                                          <span class="popover-date-block">
                                            <span class="popover-date-label">End:</span>
                                            <span class="popover-date-value">{{#if endDate}}{{endDate}}{{else}}No Date Set{{/if}}</span>
                                          </span>
                                        </div>
                                        {{#if projects}}
                                        <h5><div class="projects-lozenge">Projects</div></h5>
                                            <ul class="popover-projects">
                                                    {{#each projects}}
                                                        <li class="project-item">
                                                            <div class="project-name">{{name}}</div>
                                                            <div class="popover-dates" style="font-size:0.9em;">
                                                                <span class="popover-date-block">
                                                                    <span class="popover-date-label">Start:</span>
                                                                    <span class="popover-date-value">{{#if start}}{{start}}{{else}}No Date Set{{/if}}</span>
                                                                </span>
                                                                <span class="popover-date-block">
                                                                    <span class="popover-date-label">End:</span>
                                                                    <span class="popover-date-value">{{#if end}}{{end}}{{else}}No Date Set{{/if}}</span>
                                                                </span>
                                                            </div>
                                                        </li>
                                                    {{/each}}
                                                </ul>
                                        {{/if}}
                                    </div>
                                    <div class="popover-title-source"><xsl:attribute name="id">pop-title-{{popoverId}}</xsl:attribute>
                                     {{{essRenderInstanceMenuLink this}}}
                                    </div>
                                {{/each}}
                            </div>
                        {{/each}}
                    {{/each}}
                    <div class="enabling-section-outer" id="enablingSection">
                        <div class="bottom-section-title">
                            <h4>Enabling Changes and Initiatives</h4>
                        </div> 
                        <div id="enablingGoalsContainer" class="roadmap-wrapper">
                            <div class="roadmap-rows enabling-rows">
                                {{#each supportingObjectives}}
                                    <div role="gridcell" class="capability-cell spanning popover-trigger">
                                        <xsl:attribute name="aria-label">Supporting Objective: {{name}}. Press Enter or Space for details.</xsl:attribute>
                                        <xsl:attribute name="tabindex">0</xsl:attribute>
                                        <xsl:attribute name="data-toggle">popover</xsl:attribute>
                                        <xsl:attribute name="data-popover-id">pop-{{#if popoverId}}{{popoverId}}{{else}}{{id}}{{/if}}</xsl:attribute>
                                        <xsl:attribute name="style">grid-column: 2; grid-row: span {{span}}</xsl:attribute>
                                        {{this.name}}
                                    </div>
                                    <div class="popover-content-source">
                                        <xsl:attribute name="id">pop-{{#if popoverId}}{{popoverId}}{{else}}{{id}}{{/if}}</xsl:attribute>
                                        <div class="popover-description">
                                            {{#if description}}{{description}}{{else}}No description set{{/if}}
                                        </div>
                                    </div>
                                    <div class="popover-title-source">
                                        <xsl:attribute name="id">pop-title-{{#if popoverId}}{{popoverId}}{{else}}{{id}}{{/if}}</xsl:attribute>
                                     {{{essRenderInstanceMenuLink this}}}
                                    </div>

                                    <div role="gridcell" class="timeline-cell spanning-plan">
                                        <xsl:attribute name="style">grid-column: 3; grid-row: span {{span}}; --obj-color: #cbd5e0; --obj-color-alt: #f7fafc; --timeline-years: {{../timelineYearsCount}}; display: grid; grid-template-rows: repeat({{span}}, minmax(36px, auto)); grid-template-columns: repeat({{../timelineYearsCount}}, 1fr); gap: 1px;</xsl:attribute>
                                        {{#each plans}}
                                            {{#each timelineBars}}
                                            <div class="timeline-bar-container">
                                                <xsl:attribute name="style">grid-column: {{startIndex}} / {{endIndex}}; grid-row: calc({{../rowOffset}} + {{laneOffset}} - 1);</xsl:attribute>
                                                
                                                <div class="timeline-bar popover-trigger" style="background: #cbd5e0; color: #4a5568 !important;">
                                                    <xsl:attribute name="role">button</xsl:attribute>
                                                    <xsl:attribute name="tabindex">0</xsl:attribute>
                                                    <xsl:attribute name="data-toggle">popover</xsl:attribute>
                                                    <xsl:attribute name="data-popover-id">pop-{{../popoverId}}</xsl:attribute>
                                                    
                                                    <div class="timeline-bar-title" style="color: #4a5568 !important;">
                                                        {{title}}
                                                        {{#if ../startDate}}{{else}} <i class="fa fa-warning" style="color:#d21212"></i> {{/if}}
                                                    </div>
                                                </div>
                                            </div>
                                            {{/each}}
                                            <!-- Popover content for supporting plans -->
                                            <div class="popover-content-source">
                                                <xsl:attribute name="id">pop-{{popoverId}}</xsl:attribute>
                                                <div class="popover-dates">
                                                  <span class="popover-date-block">
                                                    <span class="popover-date-label">Start:</span>
                                                    <span class="popover-date-value">{{#if startDate}}{{startDate}}{{else}}No Date Set{{/if}}</span>
                                                  </span>
                                                  <span class="popover-date-block">
                                                    <span class="popover-date-label">End:</span>
                                                    <span class="popover-date-value">{{#if endDate}}{{endDate}}{{else}}No Date Set{{/if}}</span>
                                                  </span>
                                                </div>
                                                {{#if projects}}
                                                <h5><div class="projects-lozenge">Projects</div></h5>
                                                    <ul class="popover-projects">
                                                            {{#each projects}}
                                                                <li class="project-item">
                                                                    <div class="project-name">{{name}}</div>
                                                                    <div class="popover-dates" style="font-size:0.9em;">
                                                                         <span class="popover-date-block">
                                                                            <span class="popover-date-label">Start:</span>
                                                                            <span class="popover-date-value">{{#if start}}{{start}}{{else}}No Date Set{{/if}}</span>
                                                                        </span>
                                                                        <span class="popover-date-block">
                                                                            <span class="popover-date-label">End:</span>
                                                                            <span class="popover-date-value">{{#if end}}{{end}}{{else}}No Date Set{{/if}}</span>
                                                                        </span>
                                                                    </div>
                                                                </li>
                                                            {{/each}}
                                                        </ul>
                                                {{/if}}
                                            </div>
                                            <div class="popover-title-source"><xsl:attribute name="id">pop-title-{{popoverId}}</xsl:attribute>
                                             {{{essRenderInstanceMenuLink this}}}
                                            </div>
                                        {{/each}}
                                    </div>
                                {{/each}}
                            </div>
                        </div>
                    </div>
                </script>

                <script id="enabling-template" type="text/x-handlebars-template">
                    {{#each items}}
                        <div>
                            <xsl:attribute name="class">enabling-item</xsl:attribute>
                            <xsl:attribute name="role">listitem</xsl:attribute>
                            <xsl:attribute name="tabindex">0</xsl:attribute>
                            <xsl:attribute name="aria-label">{{category}}: {{description}}</xsl:attribute>
                            <xsl:attribute name="style">animation-delay: {{multiply @index 0.1}}s</xsl:attribute>
                            <div class="enabling-bullet">•</div>
                            <div class="enabling-text">
                                <strong>{{category}}: </strong>
                                <span class="enabling-description">{{description}}</span>
                            </div>
                        </div>
                    {{/each}}
                </script>

                <script id="dependencies-template" type="text/x-handlebars-template">
                    {{#each items}}
                        <div>
                            <xsl:attribute name="class">dependency-item</xsl:attribute>
                            <xsl:attribute name="role">listitem</xsl:attribute>
                            <xsl:attribute name="tabindex">0</xsl:attribute>
                            <xsl:attribute name="aria-label">Dependency: {{this}}</xsl:attribute>
                            <xsl:attribute name="style">animation-delay: {{multiply @index 0.1}}s</xsl:attribute>
                            {{this}}
                        </div>
                    {{/each}}
                </script>

                <script id="metrics-template" type="text/x-handlebars-template">
                    {{#each this}} 
                        <div>
                            <xsl:attribute name="class">metric-item tooltip</xsl:attribute>
                            <xsl:attribute name="role">listitem</xsl:attribute>
                            <xsl:attribute name="tabindex">0</xsl:attribute>
                            <xsl:attribute name="aria-label">Metric: {{this.quality}}</xsl:attribute>
                            <xsl:attribute name="data-tooltip">{{this.description}}</xsl:attribute>
                            <xsl:attribute name="style">animation-delay: {{multiply @index 0.1}}s; border-left:0px</xsl:attribute>
                           <i class="fa fa-square"><xsl:attribute name="style">color: {{qualityColour this.quality}};</xsl:attribute></i> {{this.quality}}
                        </div>
                    {{/each}}
                </script>

                <script id="risks-template" type="text/x-handlebars-template">
                    {{#each indicators}}
                        <div>
                            <xsl:attribute name="class">risk-indicator tooltip</xsl:attribute>
                            <xsl:attribute name="style">background-color: {{color}}; animation-delay: {{multiply @index 0.2}}s</xsl:attribute>
                            <xsl:attribute name="data-tooltip">{{label}}</xsl:attribute>
                        </div>
                    {{/each}}
                </script>

                <script id="years-template" type="text/x-handlebars-template">
                    {{#each years}}
                        <div>
                            <xsl:attribute name="class">timeline-year</xsl:attribute>
                            {{label}}
                        </div>
                    {{/each}}
                </script>


                <xsl:call-template name="Footer"/>

                <script>
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>
                    <xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
                    let businessModels = [<xsl:apply-templates select="$businessModels" mode="busModels"/>];
                    let businessObjectives =[<xsl:apply-templates select="$businessObjectives" mode="busObjectives"/>];
                     console.log('businessObjectives:', businessObjectives);
                    let stratPlans = [<xsl:apply-templates select="$strategicPlans" mode="stratPlans"/>];
                    // Populated at runtime after filtering goals/objectives
                    let inScopeQualities = [];

                    <xsl:text disable-output-escaping="yes"><![CDATA[
                    //console.log('businessModels:', businessModels);
                          //console.log('stratPlans:', stratPlans);
                    // Define the APIs to fetch
                    const apiList = [
                         'strategyData', 'planDataAPI'
                    ];
                    
                    let data;
                    let allPlansCache = [];
                    let objectivesByIdCache = new Map();
                    let objectiveClassByIdCache = new Map();
                    let plansByObjectiveCache = new Map();
 

                    const ROADMAP_DATA = {
                        "metadata": {
                            "title": "",
                            "version": "V 0.4",
                            "lastUpdated": "2026-01-12"
                        },
                        "drivers": [
                            {
                                "id": "store_90_Class130001",
                                "name": "Customer Retention",
                                "title": "Customer Retention",
                                "goals": [
                                    {
                                        "id": "store_53_Class66",
                                        "name": "Improve Customer Satisfaction",
                                        "objectives": [
                                            {
                                                "id": "store_53_Class104",
                                                "name": "Increase Up Sales and Cross sales",
                                                "title": "Increase Up Sales and Cross sales",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class106",
                                                "name": "Increasing Levels of Gross Sales",
                                                "title": "Increasing Levels of Gross Sales",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class108",
                                                "name": "Increasing Levels of Net New Business",
                                                "title": "Increasing Levels of Net New Business",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class112",
                                                "name": "Manage our Clients Effectively",
                                                "title": "Manage our Clients Effectively",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class120",
                                                "name": "Reduce Client Reporting Delivery Time",
                                                "title": "Reduce Client Reporting Delivery Time",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class132",
                                                "name": "Enhance Meter Data Analysis Capbabilities",
                                                "title": "Enhance Meter Data Analysis Capbabilities",
                                                "description": "",
                                                "plans": [
                                                    {
                                                        "id": "store_67_Class330",
                                                        "name": "Meter Supply Improvement",
                                                        "description": "Review how the installation and supply of meters can be improved to reduce cost and increase customer satisfaction",
                                                        "validStartDate": "2018-05-01",
                                                        "validEndDate": "2023-12-01",
                                                        "planStatus": "Not Set",
                                                        "projects": [
                                                            {
                                                                "id": "store_67_Class1",
                                                                "name": "Faster Meter Implementation",
                                                                "description": "Reduction of the meter install time",
                                                                "proposedStartDate": "2018-06-01",
                                                                "targetEndDate": "2021-04-09"
                                                            },
                                                            {
                                                                "id": "store_67_Class303",
                                                                "name": "Implement Geographic Metering Processes Improvements",
                                                                "description": "Implement Geographic Metering Processes Improvements defined",
                                                                "proposedStartDate": "2019-09-01",
                                                                "targetEndDate": "2019-12-31"
                                                            }
                                                        ]
                                                    }
                                                ]
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                "id": "store_90_Class130001",
                                "name": "Customer Satisfaction",
                                "title": "Customer Satisfaction",
                                "goals": [
                                    {
                                        "id": "store_53_Class66",
                                        "name": "Improve Customer Satisfaction",
                                        "objectives": [
                                            {
                                                "id": "store_53_Class104",
                                                "name": "Increase Up Sales and Cross sales",
                                                "title": "Increase Up Sales and Cross sales",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class106",
                                                "name": "Increasing Levels of Gross Sales",
                                                "title": "Increasing Levels of Gross Sales",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class108",
                                                "name": "Increasing Levels of Net New Business",
                                                "title": "Increasing Levels of Net New Business",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class112",
                                                "name": "Manage our Clients Effectively",
                                                "title": "Manage our Clients Effectively",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class120",
                                                "name": "Reduce Client Reporting Delivery Time",
                                                "title": "Reduce Client Reporting Delivery Time",
                                                "description": "",
                                                "plans": []
                                            },
                                            {
                                                "id": "store_53_Class132",
                                                "name": "Enhance Meter Data Analysis Capbabilities",
                                                "title": "Enhance Meter Data Analysis Capbabilities",
                                                "description": "",
                                                "plans": [
                                                    {
                                                        "id": "store_67_Class330",
                                                        "name": "Meter Supply Improvement",
                                                        "description": "Review how the installation and supply of meters can be improved to reduce cost and increase customer satisfaction",
                                                        "validStartDate": "2028-05-01",
                                                        "validEndDate": "2029-12-01",
                                                        "planStatus": "Not Set",
                                                        "projects": [
                                                            {
                                                                "id": "store_67_Class1",
                                                                "name": "Faster Meter Implementation",
                                                                "description": "Reduction of the meter install time",
                                                                "proposedStartDate": "2026-06-01",
                                                                "targetEndDate": "2026-04-09"
                                                            },
                                                            {
                                                                "id": "store_67_Class303",
                                                                "name": "Implement Geographic Metering Processes Improvements",
                                                                "description": "Implement Geographic Metering Processes Improvements defined",
                                                                "proposedStartDate": "2028-09-01",
                                                                "targetEndDate": "2029-12-31"
                                                            }
                                                        ]
                                                    }
                                                ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        ],
                        "sections": {
                            "objectives": { "title": "objectives" },
                            "capabilities": { "title": "UNI capabilities' actions" },
                            "digitalActions": { "title": " digital strategic actions" },
                            "timeline": {
                                "title": "Strategic Roadmap",
                                "years": [
                                    { "label": "2025", "value": 2025 },
                                    { "label": "2026", "value": 2026 },
                                    { "label": "2027", "value": 2027 },
                                    { "label": "2028-32", "value": 2028 }
                                ],
                                "items": [
                                    { "id": "unified-portal", "title": "CRM Implementation", "category": "unified", "startYear": 2025, "endYear": 2025, "objectiveId": "store_53_Class104" },
                                    { "id": "sales-init", "title": "Sales Optimisation", "category": "unified", "startYear": 2026, "endYear": 2027, "objectiveId": "store_53_Class106" }
                                ]
                            }
                        },
                        "enablingChanges": {
                            "title": "Enabling changes and initiatives",
                            "items": [
                                { "category": "Data Platforms", "description": "Enable data driven decision making" },
                                { "category": "UX", "description": "Make digital platforms easy to use" }
                            ]
                        },
                        "dependencies": {
                            "title": "Key dependencies and risks",
                            "items": ["Data hub", "Reporting hub"]
                        },
                        "metrics": {
                            "title": "Metrics/KPIs",
                            "items": ["Up-sales %", "Employee Retention Rate"]
                        },
                        "risks": {
                            "indicators": [
                                { "color": "#FF6B35", "label": "High Risk" },
                                { "color": "#F7B731", "label": "Medium Risk" },
                                { "color": "#00A8A8", "label": "Low Risk" }
                            ]
                        }
                    };

                 

                    let timelineState = {
                        startYear: new Date().getFullYear(),
                        endYear: new Date().getFullYear() + 4
                    };

                    function updateTimelineData() {
                        const years = [];
                        for (let y = timelineState.startYear; y <= timelineState.endYear; y++) {
                            years.push({ label: String(y), value: y });
                        }
                        ROADMAP_DATA.sections.timeline.years = years;
                    }

                    function makeSafeId(raw) {
                        return String(raw || '').replace(/[^A-Za-z0-9_-]/g, '_');
                    }



                    function scrollRoadmapTo(targetId) {
                        const container = document.querySelector('.roadmap-wrapper');
                        const target = document.getElementById(targetId);
                        if (!container || !target) return;
                        const headerRowEl = container.querySelector('.timeline-header-cell') || container.querySelector('.section-title');
                        const yearsEl = container.querySelector('.timeline-years');
                        const headerOffset =
                            (headerRowEl ? headerRowEl.offsetHeight : 0) +
                            (yearsEl ? yearsEl.offsetHeight : 0) +
                            8;
                        const containerRect = container.getBoundingClientRect();
                        const targetRect = target.getBoundingClientRect();
                        const offset = targetRect.top - containerRect.top + container.scrollTop - headerOffset;
                        container.scrollTo({ top: offset, behavior: 'smooth' });
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        $(document).on('click', '.jump-btn', function() {
                            const targetId = this.getAttribute('data-jump');
                            if (targetId) scrollRoadmapTo(targetId);
                            $('.jump-btn').removeClass('active');
                            $(this).addClass('active');
                        });
                        const defaultJumpBtn = document.querySelector('.jump-btn[data-jump="roadmapRows"]');
                        if (defaultJumpBtn) defaultJumpBtn.classList.add('active');
                        $(document).on('click', '#btn-start-down', function() {
                            //console.log('Navigation: Start Year -');
                            timelineState.startYear--;
                            initializeRoadmap();
                        });
                        $(document).on('click', '#btn-start-up', function() {
                            //console.log('Navigation: Start Year +');
                            if (timelineState.startYear < timelineState.endYear) {
                                timelineState.startYear++;
                                initializeRoadmap();
                            }
                        });
                        $(document).on('click', '#btn-end-down', function() {
                            //console.log('Navigation: End Year -');
                            if (timelineState.endYear > timelineState.startYear) {
                                timelineState.endYear--;
                                initializeRoadmap();
                            }
                        });
                        $(document).on('click', '#btn-end-up', function() {
                            //console.log('Navigation: End Year +');
                            timelineState.endYear++;
                            initializeRoadmap();
                        });
                        Handlebars.registerHelper('multiply', function(a, b) {
                            return (a * b).toFixed(2);
                        });

                        // Stable pseudo-random colour based on a string (so colours don't change on every re-render)
                        const __hashString = (str) => {
                            const s = String(str || '');
                            let h = 0;
                            for (let i = 0; i < s.length; i++) {
                                h = ((h << 5) - h) + s.charCodeAt(i);
                                h |= 0; // 32-bit
                            }
                            return Math.abs(h);
                        };

                        const __colourFromString = (str) => {
                            const h = __hashString(str) % 360;           // hue
                            const s = 70;                                // saturation
                            const l = 45;                                // lightness
                            return `hsl(${h}, ${s}%, ${l}%)`;
                        };

                        Handlebars.registerHelper('qualityColour', function (qualityText) {
                            return __colourFromString(qualityText);
                        });

     

                        try {
                            // Kick off the core fetcher
                            fetchAndRenderData(apiList).then((response) => {
                                data = response;
                                renderData();
                            }).catch(err => {
                                console.error(err);
                                document.getElementById('status').innerHTML =
                                    '<span style="color: red;">Error: ' + err.message + '</span>';
                            });
                        } catch (err) {
                            console.error(err);
                        }
                    });
                    // Called automatically when all APIs are loaded
                    function renderData() {
                      try {
                        //console.log('APIs loaded, building JSON structure...', data);

                        // Correctly reference the loaded API payloads
                        const strategyData = data.strategyData || {};
                        const planData = data.planDataAPI || {};

                        // Extract arrays from API responses (defensive in case of missing data)
                        const drivers = strategyData.drivers || [];
                        const goals = strategyData.goals || [];
                        const objectives = strategyData.objectives || [];

                        // businessObjectives is authored in this view and includes the authoritative objective class type.
                        const objectiveClassById = new Map(
                            (businessObjectives || [])
                                .filter(bo => bo && bo.id)
                                .map(bo => [bo.id, bo.className])
                        );
                        objectiveClassByIdCache = objectiveClassById;
                        const objectivesNormalized = (objectives || []).map(obj => ({
                            ...obj,
                            className: objectiveClassById.get(obj.id) || obj.className || obj.class || 'Business_Objective'
                        }));

                        // allPlans often comes back as an array of { key, value } objects
                        const allPlansRaw = planData.allPlans || [];

                        // Normalise plans: the API sometimes returns [{key,value}] items
                        const allPlansBase = Array.isArray(allPlansRaw)
                          ? allPlansRaw.map(p => (p && p.value) ? p.value : p)
                          : Object.values(allPlansRaw);

                        // Merge in extra fields from `stratPlans` (e.g. short_name) by matching on plan id
                        const stratPlansArr = Array.isArray(stratPlans) ? stratPlans : [];
                        const stratPlansById = new Map(
                          stratPlansArr
                            .filter(sp => sp && sp.id)
                            .map(sp => [sp.id, sp])
                        );

            

                        const allPlans = allPlansBase.map(p => {
                          if (!p || !p.id) return p;
                          const sp = stratPlansById.get(p.id);
                          if (!sp) {
                            // Ensure consistent shape even when no stratPlan match
                            return {
                              ...p,
                              short_name: p.short_name || '',
                              supports_strategic_plan: Array.isArray(p.supports_strategic_plan) ? p.supports_strategic_plan : (p.supports_strategic_plan ? [].concat(p.supports_strategic_plan) : []),
                              description: p.description || p.plan_description || p.planDescription || ''
                            };
                          }

                          return {
                            ...p,
                            // Prefer stratPlans.short_name when present, otherwise keep existing
                            short_name: (sp.short_name != null && sp.short_name !== '')
                              ? sp.short_name
                              : (p.short_name || ''),

                            // Prefer stratPlans.supports_strategic_plan when present, otherwise keep existing
                            supports_strategic_plan: Array.isArray(sp.supports_strategic_plan)
                              ? sp.supports_strategic_plan
                              : (Array.isArray(p.supports_strategic_plan)
                                  ? p.supports_strategic_plan
                                  : (p.supports_strategic_plan ? [].concat(p.supports_strategic_plan) : [])),

                            depends_on_strategic_plans: Array.isArray(sp.depends_on_strategic_plans)
                              ? sp.depends_on_strategic_plans
                              : (Array.isArray(p.depends_on_strategic_plans) ? p.depends_on_strategic_plans : []),
                            
                            strategic_plan_supports_objective: Array.isArray(sp.strategic_plan_supports_objective)
                              ? sp.strategic_plan_supports_objective
                              : (Array.isArray(p.strategic_plan_supports_objective) ? p.strategic_plan_supports_objective : []),

                            // Prefer existing plan description, but be defensive about possible property names
                            description: (p.description || p.plan_description || p.planDescription || sp.description || '')
                          };
                        });
//console.log('allPlans:', allPlans);

                        // Exclude plans with status outside DSP window
                        const excludedStatuses = ['0. Roadmap Idea (Outside DSP 25-32)', '0. Roadmap Idea (Unplanned)'];
                        const filteredPlans = allPlans.filter(p => !excludedStatuses.includes(p.planStatus));

                        // Calculate initial endYear from data
                        let maxYear = timelineState.startYear + 2;
                        filteredPlans.forEach(p => {
                            if (p.validEndDate) {
                                const y = parseInt(p.validEndDate.split('-')[0]);
                                if (!isNaN(y) && y > maxYear) maxYear = y;
                            }
                        });
                        timelineState.endYear = maxYear;
                        updateTimelineData();

                
                        

                        // Build lookup maps for efficient linking
                        const goalsById = new Map((goals || []).map(g => [g.id, g]));
                        const objectivesById = new Map((objectivesNormalized || []).map(o => [o.id, o]));

                        // Build plans-by-objective map
                        const plansByObjective = new Map();

                        const summarisePlan = (plan) => {
                          if (!plan) return null;
                          return {
                            id: plan.id,
                            name: plan.name,
                            short_name: plan.short_name || '',
                            supports_strategic_plan: plan.supports_strategic_plan || [],
                            depends_on_strategic_plans: plan.depends_on_strategic_plans || [],
                            strategic_plan_supports_objective: plan.strategic_plan_supports_objective || [],
                            description: plan.description || '',
                            validStartDate: plan.validStartDate || null,
                            validEndDate: plan.validEndDate || null,
                            planStatus: plan.planStatus || 'Not Set',
                            // keep these for downstream use (optional but useful)
                            projects: plan.projects || [],
                            planP2E: plan.planP2E || []
                          };
                        };

                        filteredPlans.forEach(plan => {
                          const planObjectives = (plan && plan.objectives) ? plan.objectives : [];
                          planObjectives.forEach(objRef => {
                            const objId = (typeof objRef === 'string') ? objRef : (objRef && objRef.id);
                            if (!objId) return;

                            if (!plansByObjective.has(objId)) {
                              plansByObjective.set(objId, []);
                            }
                            const summary = summarisePlan(plan);
                            if (summary) {
                              plansByObjective.get(objId).push(summary);
                            }
                          });
                        });
                        objectivesByIdCache = objectivesById;
                        plansByObjectiveCache = plansByObjective;
                        allPlansCache = filteredPlans;

                        // Helpers to resolve IDs or inline objects
                        const resolveGoal = (gRef) => {
                          if (!gRef) return null;
                          if (typeof gRef === 'string') return goalsById.get(gRef) || { id: gRef };
                          if (gRef.id && goalsById.has(gRef.id)) return goalsById.get(gRef.id);
                          return gRef;
                        };

                        const resolveObjective = (oRef) => {
                          if (!oRef) return null;
                          if (typeof oRef === 'string') return objectivesById.get(oRef) || { id: oRef };
                          if (oRef.id && objectivesById.has(oRef.id)) return objectivesById.get(oRef.id);
                          return oRef;
                        };

                        // Build the hierarchical JSON structure, now including plans under objectives
                        const viewModel = {
                          drivers: (drivers || []).map(driver => {
                            const driverGoals = (driver && driver.goals) ? driver.goals : [];

                            return {
                              id: driver.id,
                              name: driver.name,
                              title: driver.name || '',
                              description: driver.description || '',
                              goals: driverGoals.map(gRef => {
                                const goal = resolveGoal(gRef) || {};

                                // Different APIs model this differently, so try a few likely property names
                                const goalObjectives = goal.objectives || goal.objectiveIds || goal.objectivesIds || [];

                                return {
                                  id: goal.id,
                                  name: goal.name || '',
                                  title: goal.name || '',
                                  description: goal.description || '',
                                  objectives: (goalObjectives || []).map(oRef => {
                                    const obj = resolveObjective(oRef) || {};
                                    const objId = obj.id;

                                    return {
                                      id: objId,
                                      name: obj.name || '',
                                      title: obj.name || '',
                                      className: obj.className,
                                      description: obj.description || '',
                                      plans: objId ? (plansByObjective.get(objId) || []) : []
                                    };
                                  })
                                };
                              })
                            };
                          }),

                          // Handy top-level list too (useful for debugging / direct rendering)
                          objectives: (objectivesNormalized || []).map(o => ({
                            id: o.id,
                            name: o.name,
                            title: o.name || '',
                            className: o.className,
                            description: o.description || '',
                            plans: (o.id ? (plansByObjective.get(o.id) || []) : [])
                          }))
                        };
 
                        //console.log('viewModel', viewModel);
                        ROADMAP_DATA.drivers=viewModel.drivers;
                        
                        const mainTitleText = document.getElementById('mainTitleText');
                        if (mainTitleText) mainTitleText.textContent = ROADMAP_DATA.metadata.title;
                        
                        const versionBadge = document.getElementById('versionBadge');
                        if (versionBadge) versionBadge.textContent = ROADMAP_DATA.metadata.version;

                        const timelineTitle = document.getElementById('timelineTitle');
                        if (timelineTitle) timelineTitle.textContent = ROADMAP_DATA.sections.timeline.title;

                        populateBMSelector();
                        initializeRoadmap();

                      } catch (err) {
                        console.error('Error in renderData:', err);
                      }
                    }

                    function populateBMSelector() {
                        const selector = document.getElementById('bm-selector');
                        if (!selector || !businessModels) return;

                        // Clear existing options except the first "All" option
                        while (selector.options.length > 1) {
                            selector.remove(1);
                        }

                        businessModels.forEach(bm => {
                            //if(bm.name === 'Supporting UCL'){return}
                            const option = document.createElement('option');
                            option.value = bm.id;
                            option.easvalue = bm.name;
                            option.textContent = bm.short_name || bm.name;
                            selector.appendChild(option);
                        });

                        selector.addEventListener('change', (e) => {
                        //filter goals 
                            initializeRoadmap();
                        });
                    }
                    
                    function renderTemplate(templateId, containerId, data) {
                        const container = document.getElementById(containerId);
                        if (!container) {
                            console.warn(`Container '${containerId}' not found, skipping render for template '${templateId}'`);
                            return;
                        }
                        const source = document.getElementById(templateId).innerHTML;
                        const template = Handlebars.compile(source);
                        const html = template(data);
                        container.innerHTML = html;
                    }

                    function updateRoadmapHeaderVars() {
                        const grid = document.getElementById('roadmapRows');
                        if (!grid) return;
                        const objectivesTitle = grid.querySelector('#objectivesTitle');
                        const timelineHeader = grid.querySelector('.timeline-header-cell');
                        const titleHeight = objectivesTitle ? objectivesTitle.getBoundingClientRect().height : 0;
                        const headerHeight = timelineHeader ? timelineHeader.getBoundingClientRect().height : 0;
                        const rowHeight = Math.max(titleHeight, headerHeight);
                        if (rowHeight) {
                            grid.style.setProperty('--roadmap-header-row-height', `${Math.ceil(rowHeight)}px`);
                        }
                    }

                    function initRoadmapPopovers() {
                        if (typeof $ === 'undefined' || !$.fn || !$.fn.popover) return;

                        const popoverOptions = {
                            html: true,
                            sanitize: false,
                            trigger: 'manual',
                            container: 'body',
                            placement: function () {
                                if (this.classList && this.classList.contains('capability-cell')) return 'right';
                                return 'auto';
                            },
                            title: function () {
                                const popId = this.getAttribute('data-popover-id');
                                const suffix = popId ? popId.replace(/^pop-/, '') : '';
                                const titleEl = document.getElementById('pop-title-' + suffix);
                                if (titleEl && titleEl.innerHTML.trim()) return titleEl.innerHTML;
                                const titleNode = this.querySelector('.timeline-bar-title');
                                return titleNode ? titleNode.textContent : '';
                            },
                            content: function () {
                                const popId = this.getAttribute('data-popover-id');
                                const contentEl = popId ? document.getElementById(popId) : null;
                                return contentEl ? contentEl.innerHTML : '';
                            }
                        };
                        window.roadmapPopoverOptions = popoverOptions;

                        // Unified delegated handler for click and keydown
                        $(document)
                            .off('click.roadmap-popover-toggle', '.popover-trigger')
                            .on('click.roadmap-popover-toggle', '.popover-trigger', function (e) {
                                e.preventDefault();
                                e.stopPropagation();
                                const $this = $(this);
                                if (!$this.data('bs.popover') && !$this.data('popover')) {
                                    $this.popover(popoverOptions);
                                }
                                $('.popover-trigger').not(this).popover('hide');
                                $this.popover('toggle');
                            })
                            .off('keydown.roadmap-popover-toggle', '.popover-trigger')
                            .on('keydown.roadmap-popover-toggle', '.popover-trigger', function (e) {
                                if (e.key === 'Enter' || e.key === ' ') {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    const $this = $(this);
                                    if (!$this.data('bs.popover') && !$this.data('popover')) {
                                        $this.popover(popoverOptions);
                                    }
                                    $('.popover-trigger').not(this).popover('hide');
                                    $this.popover('toggle');
                                }
                                if (e.key === 'Escape') {
                                    e.preventDefault();
                                    $('.popover-trigger').popover('hide');
                                }
                            });

                        // Click outside closes
                        $(document).off('click.roadmap-popovers').on('click.roadmap-popovers', function (e) {
                            const $t = $(e.target);
                            if (!$t.closest('.popover').length && !$t.closest('.popover-trigger').length) {
                                $('.popover-trigger').popover('hide');
                            }
                        });
                    }

                    function exportToPPTX() {
                        if (typeof PptxGenJS === 'undefined') {
                            alert('PowerPoint library not loaded yet. Please wait a moment and try again.');
                            return;
                        }

                        const pptx = new PptxGenJS();
                        pptx.layout = 'LAYOUT_16x9'; 
                        
                        pptx.defineSlideMaster({
                            title: 'MASTER_SLIDE',
                            background: { color: 'FFFFFF' },
                            objects: [
                                { 'line': { x: 0.5, y: 0.85, w: 9.0, h: 0, line: { color: '003366', width: 1.5 } } },
                                { 'text': { text: 'Strategic Roadmap', options: { x: 0.5, y: 0.2, w: 4, h: 0.5, fontSize: 18, color: '003366', bold: true } } }
                            ]
                        });

                        // 1. Title Slide
                        const titleSlide = pptx.addSlide();
                        titleSlide.background = { color: '003366' };
                        titleSlide.addText("Strategic Roadmap", {
                            x: 0, y: 1.8, w: '100%', h: 1,
                            fontSize: 44, color: 'FFFFFF', bold: true, align: 'center', fontFace: 'Inter'
                        });
                        titleSlide.addText("Supporting our University", {
                            x: 0, y: 2.7, w: '100%', h: 0.5,
                            fontSize: 24, color: 'F7B731', align: 'center', fontFace: 'Inter'
                        });
                        titleSlide.addText(`Exported on: ${new Date().toLocaleDateString()}`, {
                            x: 0, y: 4.8, w: '100%', h: 0.3,
                            fontSize: 12, color: '999999', align: 'center', fontFace: 'Inter'
                        });

                        // 2. Data Slides
                        const exportData = window.__ROADMAP_EXPORT_DATA;
                        const goalsToExport = (exportData && exportData.goals) ? exportData.goals : [];
                        const supportingToExport = (exportData && exportData.supportingObjectives) ? exportData.supportingObjectives : [];

                        // 2. Main Goals Data Slides
                        goalsToExport.forEach(goal => {
                                // --- Slide A: Details ---
                                let slide = pptx.addSlide({ masterName: 'MASTER_SLIDE' });
                                slide.addText(goal.name, {
                                    x: 0.5, y: 1.0, w: 9.0, h: 0.4,
                                    fontSize: 18, color: goal.color || 'FF6B35', bold: true, fontFace: 'Inter'
                                });
                                slide.addText("Objective", { x: 0.5, y: 1.5, w: 4.0, h: 0.3, fontSize: 12, color: '666666', bold: true, fontFace: 'Inter' });
                                slide.addText("Related Initiatives", { x: 4.6, y: 1.5, w: 4.9, h: 0.3, fontSize: 12, color: '666666', bold: true, fontFace: 'Inter' });

                                let currentY = 1.8;
                                (goal.objectives || []).forEach((obj) => {
                                    const plansText = (obj.plans || [])
                                        .filter(p => p.name && p.name !== '')
                                        .map(p => "• " + p.name)
                                        .join("\n");
                                    const planCount = (obj.plans || []).length;
                                    const boxHeight = Math.max(0.6, 0.2 + (planCount * 0.18));

                                    if (currentY + boxHeight > 5.4) {
                                        slide = pptx.addSlide({ masterName: 'MASTER_SLIDE' });
                                        slide.addText(goal.name + " (cont.)", { x: 0.5, y: 1.0, w: 9.0, h: 0.4, fontSize: 18, color: goal.color || 'FF6B35', bold: true, fontFace: 'Inter' });
                                        slide.addText("Objective", { x: 0.5, y: 1.5, w: 4.0, h: 0.3, fontSize: 12, color: '666666', bold: true, fontFace: 'Inter' });
                                        slide.addText("Related Initiatives", { x: 4.6, y: 1.5, w: 4.9, h: 0.3, fontSize: 12, color: '666666', bold: true, fontFace: 'Inter' });
                                        currentY = 1.8;
                                    }

                                    slide.addText(obj.name, { x: 0.5, y: currentY, w: 4.0, h: boxHeight, fontSize: 11, color: '003366', bold: true, fill: { color: 'F1F4F8' }, valign: 'middle', margin: 8, fontFace: 'Inter' });
                                    if (plansText) {
                                        slide.addText(plansText, { x: 4.6, y: currentY, w: 4.9, h: boxHeight, fontSize: 9, color: '333333', fill: { color: 'F9F9F9' }, valign: 'top', margin: 8, fontFace: 'Inter' });
                                    } else {
                                        slide.addText("No specific initiatives listed", { x: 4.6, y: currentY, w: 4.9, h: boxHeight, fontSize: 9, color: '999999', fill: { color: 'F9F9F9' }, valign: 'middle', align: 'center', fontFace: 'Inter' });
                                    }
                                    currentY += boxHeight + 0.1;
                                });

                                // --- Slide B: Timeline Visualization ---
                                const timelineSlide = pptx.addSlide({ masterName: 'MASTER_SLIDE' });
                                timelineSlide.addText(goal.name + " (Timeline)", {
                                    x: 0.5, y: 1.0, w: 9.0, h: 0.4,
                                    fontSize: 16, color: goal.color || 'FF6B35', bold: true, fontFace: 'Inter'
                                });

                                const years = ROADMAP_DATA.sections.timeline.years || [];
                                const totalYears = years.length;
                                const chartX = 0.5;
                                const chartY = 1.6;
                                const chartW = 9.0;
                                const yearW = chartW / totalYears;

                                // Draw Year Headers
                                years.forEach((year, idx) => {
                                    timelineSlide.addText(year.value.toString(), {
                                        x: chartX + (idx * yearW), y: chartY, w: yearW, h: 0.3,
                                        fontSize: 10, color: 'FFFFFF', bold: true, align: 'center',
                                        fill: { color: '003366' }, fontFace: 'Inter'
                                    });
                                    // Vertical Grid Line
                                    timelineSlide.addShape(pptx.ShapeType.line, {
                                        x: chartX + (idx * yearW), y: chartY + 0.3, w: 0, h: 3.5,
                                        line: { color: 'EEEEEE', width: 1 }
                                    });
                                });
                                // Last grid line
                                timelineSlide.addShape(pptx.ShapeType.line, { x: chartX + chartW, y: chartY + 0.3, w: 0, h: 3.5, line: { color: 'EEEEEE', width: 1 } });

                                let tY = chartY + 0.4;
                                const flatBars = [];
                                (goal.objectives || []).forEach(obj => {
                                    (obj.plans || []).forEach(plan => {
                                        (plan.timelineBars || []).forEach(bar => {
                                            flatBars.push({ name: plan.name, ...bar });
                                        });
                                    });
                                });

                                // Draw Gantt bars
                                flatBars.forEach((bar, idx) => {
                                    if (tY > 5.2) return; // Basic overflow protection
                                    const startIdx = bar.startIndex - 1;
                                    const endIdx = bar.endIndex - 1;
                                    const barX = chartX + (startIdx * yearW);
                                    const barW = (endIdx - startIdx) * yearW;

                                    timelineSlide.addText(bar.name, {
                                        x: barX, y: tY, w: barW, h: 0.3,
                                        fontSize: 8, color: 'FFFFFF', bold: true, align: 'center',
                                        fill: { color: goal.color || 'FF6B35' }, fontFace: 'Inter',
                                        valign: 'middle'
                                    });
                                    tY += 0.4;
                                });
                        });

                        // 2.1 Supporting Objectives Data Slide
                        if (supportingToExport.length > 0) {
                            let slide = pptx.addSlide({ masterName: 'MASTER_SLIDE' });
                            slide.addText("Supporting Objectives & Initiatives", {
                                x: 0.5, y: 1.0, w: 9.0, h: 0.4,
                                fontSize: 18, color: 'FF6B35', bold: true, fontFace: 'Inter'
                            });
                            
                            let currentY = 1.5;
                            supportingToExport.forEach(obj => {
                                if (currentY > 5.2) {
                                    slide = pptx.addSlide({ masterName: 'MASTER_SLIDE' });
                                    slide.addText("Supporting Objectives (cont.)", { x: 0.5, y: 1.0, w: 9.0, h: 0.4, fontSize: 18, color: 'FF6B35', bold: true, fontFace: 'Inter' });
                                    currentY = 1.5;
                                }

                                const plans = (obj.plans || []).filter(p => p.name).map(p => p.name).join(", ");
                                slide.addText(obj.name + ": " + plans, {
                                    x: 0.5, y: currentY, w: 9.0, h: 0.5,
                                    fontSize: 10, color: '333333',
                                    fill: { color: 'F1F4F8' },
                                    margin: 8, fontFace: 'Inter'
                                });
                                currentY += 0.6;
                            });
                        }

                        // 3. Enabling Changes Slide
                        const enabling = ROADMAP_DATA.enablingChanges;
                        if (enabling && enabling.items && enabling.items.length > 0) {
                            const slide = pptx.addSlide({ masterName: 'MASTER_SLIDE' });
                            slide.addText("Enabling Changes and Initiatives", {
                                x: 0.5, y: 1.0, w: 9.0, h: 0.4,
                                fontSize: 20, color: 'FF6B35', bold: true, fontFace: 'Inter'
                            });

                            let rows = [['Category', 'Description']];
                            enabling.items.forEach(item => rows.push([item.category, item.description]));
                            
                            slide.addTable(rows, {
                                x: 0.5, y: 1.7, w: 9.0,
                                fontSize: 11,
                                color: '333333',
                                border: { type: 'solid', color: 'CCCCCC', pt: 0.5 },
                                fill: { color: 'F9F9F9' },
                                colW: [2, 7],
                                rowH: 0.4,
                                valign: 'middle'
                            });
                        }

                        pptx.writeFile({ fileName: `Strategic_Roadmap_${new Date().toISOString().split('T')[0]}.pptx` });
                    }

                    function initializeRoadmap() {
                        //console.log('ROADMAP_DATA',ROADMAP_DATA)
                        updateTimelineData();
                        

                        const goals = prepareViewModel();
                        const selectBox = document.getElementById('bm-selector');
                        if (!selectBox) return;
                        const selector = selectBox.value;
                        const selectorName = selectBox.options[selectBox.selectedIndex]?.easvalue || '';

                        const bmNameEl = document.getElementById('BMName');
                        if (bmNameEl) {
                            bmNameEl.textContent = selector === 'all' ? 'All Roadmaps' :  selectorName;
                        }
                        //console.log('selected business model:', selector);

                        // Focus business models = everything except Supporting UCL
                        const focusBusinessModels = (businessModels || []).filter(bm => bm && bm.name !== 'Supporting UCL');

                        // Determine which GOAL ids are allowed for the focus section.
                        // If selector === "all" we don't filter (show all goals).
                        let allowedFocusGoalIds = null;
                        if (selector !== 'all') {
                            const selectedBM = focusBusinessModels.find(bm => bm.id === selector);
                            allowedFocusGoalIds = new Set(
                                (selectedBM && Array.isArray(selectedBM.objectives)) ? selectedBM.objectives : []
                            );
                        }

                        //console.log('selected goals:', goals);
                        //console.log('focusBusinessModels:', focusBusinessModels);

                        const filteredGoals = goals
                            .filter(goal => !allowedFocusGoalIds || allowedFocusGoalIds.has(goal.id))
                            .map(goal => {
                                const filteredObjectives = (goal.objectives || []);
                                
                                // Recalculate goal span based on its objectives
                                const newSpan = filteredObjectives.reduce((sum, obj) => sum + obj.span, 0);
                                
                                return {
                                    ...goal,
                                    objectives: filteredObjectives,
                                    span: Math.max(newSpan, 1)
                                };
                            });

                        function dedupePlansWithinGoal(goal) {
                            const seenPlanIds = new Set();

                            return {
                                ...goal,
                                objectives: (goal.objectives || []).map(obj => ({
                                ...obj,
                                plans: (obj.plans || []).filter(p => {
                                    const pid = p && p.id;
                                    if (!pid) return false;          // ignore broken items
                                    if (seenPlanIds.has(pid)) return false; // already shown somewhere under this goal
                                    seenPlanIds.add(pid);
                                    return true;
                                })
                                }))
                            };
                        }

                        const filteredGoalsDeduped = filteredGoals.map(dedupePlansWithinGoal);

                        // Build a set of plan IDs that are present in the FOCUS section
                        const focusPlanIds = new Set();
                        (filteredGoals || []).forEach(g => {
                            (g.objectives || []).forEach(o => {
                                (o.plans || []).forEach(p => {
                                    if (p && p.id) focusPlanIds.add(p.id);
                                });
                            });
                        });

                        const planSupportsFocus = (plan) => {
                            const supports = (plan && Array.isArray(plan.supports_strategic_plan))
                                ? plan.supports_strategic_plan
                                : [];
                            return supports.some(pid => focusPlanIds.has(pid));
                        };

                        //console.log('goals:', goals);
                        const timeline = ROADMAP_DATA.sections.timeline;
                        const buildSupportingPlan = (plan, objectiveId, planIndex) => {
                            const planTimeline = [];
                            const planStartDate = plan.validStartDate || '';
                            const planEndDate = plan.validEndDate || '';
                            const rawPopoverId = ((plan && plan.id) ? plan.id : 'plan') + '-' + objectiveId + '-' + planIndex;
                            const popoverId = String(rawPopoverId).replace(/[^A-Za-z0-9_-]/g, '_');

                            const pStartYear = plan.validStartDate ? parseInt(plan.validStartDate.split('-')[0]) : timelineState.startYear;
                            const pEndYear = plan.validEndDate ? parseInt(plan.validEndDate.split('-')[0]) : timelineState.startYear + 1;

                            const projects = (plan.projects || []).map(p => ({
                                name: p.name,
                                start: p.proposedStartDate,
                                end: p.targetEndDate
                            }));

                            planTimeline.push({
                                id: plan.id,
                                title: plan.name,
                                name: plan.name,
                                className: plan.className || plan.class || 'Enterprise_Strategic_Plan',
                                short_name: plan.short_name || '',
                                supports_strategic_plan: plan.supports_strategic_plan || [],
                                startYear: pStartYear,
                                endYear: pEndYear,
                                startDate: plan.validStartDate,
                                endDate: plan.validEndDate,
                                projects: projects,
                                category: 'unified'
                            });

                            const filteredTimeline = planTimeline
                                .filter(item => item.endYear >= timelineState.startYear && item.startYear <= timelineState.endYear)
                                .map(item => {
                                    let sYear = item.startYear;
                                    let eYear = item.endYear;

                                    if (sYear < timelineState.startYear) sYear = timelineState.startYear;
                                    if (eYear > timelineState.endYear) eYear = timelineState.endYear;

                                    return {
                                        ...item,
                                        startYear: sYear,
                                        endYear: eYear,
                                        startDate: item.startDate || (sYear + "-01-01"),
                                        endDate: item.endDate || (eYear + "-12-31")
                                    };
                                });

                            const timelineLanes = packTimelineItems(filteredTimeline, timeline.years);
                            const planSpan = Math.max(timelineLanes.length, 1);

                            const timelineBars = [];
                            timelineLanes.forEach((lane, laneIndex) => {
                                lane.forEach(item => {
                                    const startIndex = timeline.years.findIndex(y => y.value === item.startYear);
                                    const endIndex = timeline.years.findIndex(y => y.value === item.endYear);
                                    if (startIndex !== -1 && endIndex !== -1) {
                                        timelineBars.push({
                                            ...item,
                                            startIndex: startIndex + 1,
                                            endIndex: endIndex + 2,
                                            laneOffset: laneIndex + 1
                                        });
                                    }
                                });
                            });

                            return {
                                id: plan.id,
                                name: plan.name,
                                className: plan.className || plan.class || 'Enterprise_Strategic_Plan',
                                short_name: plan.short_name || '',
                                supports_strategic_plan: plan.supports_strategic_plan || [],
                                description: plan.description || '',
                                startDate: planStartDate,
                                endDate: planEndDate,
                                projects: projects,
                                popoverId: popoverId,
                                span: planSpan,
                                timelineBars: timelineBars
                            };
                        };

                        const supportingPlans = (allPlansCache || []).filter(planSupportsFocus);
                        let supportingObjectivesMap = new Map();

                        // Build a set of goal and objective IDs currently in the Focus section to exclude them from Supporting
                        const focusGoalAndObjIds = new Set();
                        (filteredGoalsDeduped || []).forEach(g => {
                            focusGoalAndObjIds.add(g.id);
                            (g.objectives || []).forEach(o => focusGoalAndObjIds.add(o.id));
                        });

                        (supportingPlans || []).forEach(plan => {
                            const planObjectives = (plan && plan.objectives) ? plan.objectives : [];
                            planObjectives.forEach(objRef => {
                            //console.log('Processing plan objective reference:', objRef);
                                const objId = (typeof objRef === 'string') ? objRef : (objRef && objRef.id);
                                if (!objId || focusGoalAndObjIds.has(objId)) return; // Skip if in focus

                                if (!supportingObjectivesMap.has(objId)) {
                                    const cached = objectivesByIdCache.get(objId);
                                    const resolved = (typeof objRef === 'object' && objRef) ? objRef : (cached || { id: objId });
                                    supportingObjectivesMap.set(objId, {
                                        ...resolved,
                                        id: objId,
                                        name: resolved.name || resolved.title || cached?.name || cached?.title || objId,
                                        title: resolved.title || resolved.name || cached?.title || cached?.name || objId,
                                        description: resolved.description || cached?.description || '',
                                        className: objectiveClassByIdCache.get(objId) || resolved.className || resolved.class || cached?.className || cached?.class || 'Business_Objective',
                                        popoverId: makeSafeId('obj-supp-' + objId)
                                    });
                                }
                            });
                        });

                        let supportingObjectives = Array.from(supportingObjectivesMap.values())
                            .map(obj => {
                                const supportingPlansRaw = (plansByObjectiveCache.get(obj.id) || []).filter(planSupportsFocus);
                                if (supportingPlansRaw.length === 0) return null;

                                const seenPlanIds = new Set();
                                const supportingPlansForObj = supportingPlansRaw
                                    .filter(p => {
                                        const pid = p && p.id;
                                        if (!pid) return false;
                                        if (seenPlanIds.has(pid)) return false;
                                        seenPlanIds.add(pid);
                                        return true;
                                    })
                                    .map((p, idx) => buildSupportingPlan(p, obj.id, idx));

                                let currentOffset = 1;
                                supportingPlansForObj.forEach(plan => {
                                    plan.rowOffset = currentOffset;
                                    currentOffset += (plan.span || 1);
                                });
                                const span = supportingPlansForObj.reduce((sum, plan) => sum + (plan.span || 1), 0) || 1;
                                return {
                                    ...obj,
                                    span: span,
                                    plans: supportingPlansForObj
                                };
                            })
                            .filter(o => o !== null);

                        // --- DYNAMIC ENABLING CHANGES ---
                        const enablingInitiatives = [];
                        const seenEnablingKey = new Set();

                        (allPlansCache || []).forEach(plan => {
                            // Find plans that focus plans DEPEND ON
                            let isDependencyOfFocus = false;
                            focusPlanIds.forEach(fId => {
                                const fPlan = allPlansCache.find(px => px.id === fId);
                                if (fPlan && fPlan.depends_on_strategic_plans && fPlan.depends_on_strategic_plans.includes(plan.id)) {
                                    isDependencyOfFocus = true;
                                }
                            });

                            if (isDependencyOfFocus) {
                                // Find any Technology Architecture Objectives supported by this dependent plan
                                const supportedObjIds = plan.strategic_plan_supports_objective || [];
                                supportedObjIds.forEach(oid => {
                                    const obj = objectivesByIdCache.get(oid);
                                    if (obj && obj.className === 'Technology_Architecture_Objective') {
                                        const key = obj.name + "||" + plan.name;
                                        if (!seenEnablingKey.has(key)) {
                                            enablingInitiatives.push({ category: obj.name, description: plan.name });
                                            seenEnablingKey.add(key);
                                        }
                                    }
                                });
                            }
                        });

                        ROADMAP_DATA.enablingChanges.items = enablingInitiatives;
                        // --- END DYNAMIC ENABLING CHANGES ---


// After you compute filteredGoals:

//console.log('filteredGoalsDeduped:', filteredGoalsDeduped);
//console.log('supportingObjectives:', supportingObjectives);
supportingObjectives=supportingObjectives.filter((o)=>{return o.className != 'Business_Objective'})
//console.log('supportingObjectives:', supportingObjectives);
// Build a set of objective IDs currently in-scope (focus + supporting)
const inScopeObjectiveIds = new Set();
(filteredGoalsDeduped || []).forEach(g => {
 
    (g.objectives || []).forEach(o => {
 
        if (o && o.id) inScopeObjectiveIds.add(o.id);
         
    });
});
(supportingObjectives || []).forEach(o => {
    if (o && o.id) inScopeObjectiveIds.add(o.id);
});
 
// Extract qualities from businessObjectives for those in-scope objectives.
// This is defensive because different APIs/views may name the field differently.
const normaliseToArray = (v) => {
    if (!v) return [];
    return Array.isArray(v) ? v : [v];
};

const qualitiesByKey = new Map();

(businessObjectives || []).forEach(bo => {
    if (!bo) return;

    // Try likely objective id keys
    const objId = bo.id || bo.objectiveId || bo.objective_id;
    
    if (!objId || !inScopeObjectiveIds.has(objId)) return;
 
    // Try likely qualities keys
    const rawQualities = bo.bo_performance_measures || [];
 
    const qualities = normaliseToArray(rawQualities);
 
    qualities.forEach(q => {
        if (!q) return;

        // Create a stable dedupe key
        const key = (typeof q === 'string')
            ? q
            : (q.id || q.quality || q.name || JSON.stringify(q));

        if (!key) return;
        if (!qualitiesByKey.has(key)) qualitiesByKey.set(key, q);
    });
});
 
// Save as a single deduped list for downstream use
inScopeQualities = Array.from(qualitiesByKey.values());
 
const normaliseQuality = (q) => (q || '').trim();

// { qualityText: { quality, ids: [...], items: [...] } }
const groupedMap = new Map();

for (const item of (inScopeQualities || [])) {
  const quality = normaliseQuality(item?.quality);
  if (!quality) continue; // skip blanks

  const id = (item?.id || '').trim();
  if (!groupedMap.has(quality)) {
    groupedMap.set(quality, { quality, ids: [], items: [] });
  }

  const group = groupedMap.get(quality);

  // keep unique ids
  if (id && !group.ids.includes(id)) group.ids.push(id);

  // optional: keep the full items too (handy for debugging)
  group.items.push(item);
}

// Final grouped array
const inScopeQualitiesGrouped = Array.from(groupedMap.values());

// If you want ONLY {quality, ids, description}:
let inScopeQualitiesByQuality = inScopeQualitiesGrouped.map(({ quality, ids, items }) => ({
    quality,
    ids,
    description: items && items[0] ? items[0].description : ''
}));
inScopeQualitiesByQuality=inScopeQualitiesByQuality.filter(q=>q.quality!=='');

//console.log('inScopeQualitiesByQuality:', inScopeQualitiesByQuality);
                        //console.log('filtered goals:', filteredGoals);
                         
                        const templateData = {
                            goals: filteredGoalsDeduped,
                            supportingObjectives: supportingObjectives,
                            years: ROADMAP_DATA.sections.timeline.years,
                            timelineYearsCount: ROADMAP_DATA.sections.timeline.years.length
                        };
                        window.__ROADMAP_EXPORT_DATA = templateData;

                        renderTemplate('roadmap-template', 'roadmapRows', templateData);

                        updateRoadmapHeaderVars();
                        initRoadmapPopovers();
                        
                        renderTemplate('enabling-template', 'enablingContainer', ROADMAP_DATA.enablingChanges);
                      //  renderTemplate('dependencies-template', 'dependenciesContainer', ROADMAP_DATA.dependencies);
                        renderTemplate('metrics-template', 'metricsContainer', inScopeQualitiesByQuality);
                      //  renderTemplate('risks-template', 'risksContainer', ROADMAP_DATA.risks);
                        

                        document.getElementById('objectivesTitle').textContent = "Strategic Goals";
                        document.getElementById('capabilitiesTitle').textContent = "Strategic Objectives";

                        
                        addStaggeredAnimations();
                        
                    }

                    function prepareViewModel() {
                        const drivers = ROADMAP_DATA.drivers;
                        const timeline = ROADMAP_DATA.sections.timeline;
                        const COLOR_PALETTE = [
                            { main: '#4A90E2', alt: '#EBF3FB' }, // Strategic Blue
                            { main: '#6C5CE7', alt: '#F3F1FF' }, // Purple
                            { main: '#00B894', alt: '#E6FBEE' }, // Teal
                            { main: '#FF7675', alt: '#FFF0F0' }, // Soft Red
                            { main: '#FDCB6E', alt: '#FFF9EB' }, // Amber
                            { main: '#0984E3', alt: '#E8F4FD' }  // Ocean Blue
                        ];

                        let colorCounter = 0;
                        const allGoals = [];
                        const seenGoalIds = new Set();
                        const seenGoalNames = new Set();

                        drivers.forEach(driver => {
                            driver.goals.forEach(goal => {
                                const goalName = (goal.name || '').trim();
                                if (seenGoalIds.has(goal.id) || (goalName && seenGoalNames.has(goalName))) return;
                                seenGoalIds.add(goal.id);
                                if (goalName) seenGoalNames.add(goalName);

                                const colorInfo = COLOR_PALETTE[colorCounter % COLOR_PALETTE.length];
                                colorCounter++;
                                
                                let totalGoalSpan = 0;
                                const objSeenIds = new Set();
                                const processedObjectives = goal.objectives
                                    .filter(obj => {
                                        if (objSeenIds.has(obj.id)) return false;
                                        objSeenIds.add(obj.id);
                                        return true;
                                    })
                                    .map(objective => {
                                    // Process plans for this objective
                                    const processedPlans = [];
                                    
                                    if (objective.plans && objective.plans.length > 0) {
                                        objective.plans.forEach((plan, planIndex) => {
                                            // Extract timeline data for this specific plan
                                            const planTimeline = [];
                                            const planStartDate = plan.validStartDate || '';
                                            const planEndDate = plan.validEndDate || '';
                                            const rawPopoverId = ((plan && plan.id) ? plan.id : 'plan') + '-' + objective.id + '-' + planIndex;
                                            const popoverId = String(rawPopoverId).replace(/[^A-Za-z0-9_-]/g, '_');
                                            
                                            const pStartYear = plan.validStartDate ? parseInt(plan.validStartDate.split('-')[0]) : timelineState.startYear;
                                            const pEndYear = plan.validEndDate ? parseInt(plan.validEndDate.split('-')[0]) : timelineState.startYear + 1;
                                            
                                            // Capture project details for plan popover
                                            const projects = (plan.projects || []).map(p => ({
                                                name: p.name,
                                                start: p.proposedStartDate,
                                                end: p.targetEndDate
                                            }));
 
                                            // Add the plan itself as a timeline item
                                            planTimeline.push({
                                                id: plan.id,
                                                title: plan.name,
                                                name: plan.name,
                                                className: 'Enterprise_Strategic_Plan',
                                                short_name: plan.short_name || '',
                                                supports_strategic_plan: plan.supports_strategic_plan || [],
                                                startYear: pStartYear,
                                                endYear: pEndYear,
                                                startDate: plan.validStartDate,
                                                endDate: plan.validEndDate,
                                                projects: projects,
                                                category: 'unified'
                                            });

                                             // Filter and clamp timeline items
                                             const filteredTimeline = planTimeline
                                                 .filter(item => item.endYear >= timelineState.startYear && item.startYear <= timelineState.endYear)
                                                 .map(item => {
                                                     let sYear = item.startYear;
                                                     let eYear = item.endYear;
                                                     
                                                     // Clamp to window
                                                     if (sYear < timelineState.startYear) sYear = timelineState.startYear;
                                                     if (eYear > timelineState.endYear) eYear = timelineState.endYear;
                                                     
                                                     return {
                                                         ...item,
                                                         startYear: sYear,
                                                         endYear: eYear,
                                                         startDate: item.startDate || (sYear + "-01-01"),
                                                         endDate: item.endDate || (eYear + "-12-31")
                                                     };
                                                 });

                                            // Pack timeline items into lanes
                                            const timelineLanes = packTimelineItems(filteredTimeline, timeline.years);
                                            const planSpan = Math.max(timelineLanes.length, 1);

                                            // Create timeline bars with grid positions
                                            const timelineBars = [];
                                            timelineLanes.forEach((lane, laneIndex) => {
                                                lane.forEach(item => {
                                                    const startIndex = timeline.years.findIndex(y => y.value === item.startYear);
                                                    const endIndex = timeline.years.findIndex(y => y.value === item.endYear);
                                                    if (startIndex !== -1 && endIndex !== -1) {
                                                        timelineBars.push({
                                                            ...item,
                                                            startIndex: startIndex + 1,
                                                            endIndex: endIndex + 2,
                                                            laneOffset: laneIndex + 1
                                                        });
                                                    }
                                                });
                                            });

                                            processedPlans.push({
                                                id: plan.id,
                                                name: plan.name,
                                                className: plan.className || plan.class || 'Enterprise_Strategic_Plan',
                                                short_name: plan.short_name || '',
                                                supports_strategic_plan: plan.supports_strategic_plan || [],
                                                description: plan.description || '',
                                                startDate: planStartDate,
                                                endDate: planEndDate,
                                                projects: projects,
                                                popoverId: popoverId,
                                                span: planSpan,
                                                timelineBars: timelineBars
                                            });
                                        });
                                    }

                                    // If no plans, create a placeholder
                                    if (processedPlans.length === 0) {
                                        const placeholderId = 'no-plan-' + objective.id;
                                        processedPlans.push({
                                            id: placeholderId,
                                            name: '',
                                            short_name: '',
                                            startDate: '',
                                            endDate: '',
                                            projects: [],
                                            popoverId: placeholderId,
                                            span: 1,
                                            timelineBars: []
                                        });
                                    }

                                     // Calculate objective span as sum of all plan spans
                                     let currentOffset = 1;
                                     processedPlans.forEach(plan => {
                                         plan.rowOffset = currentOffset;
                                         currentOffset += plan.span;
                                     });
                                     const objectiveSpan = processedPlans.reduce((sum, plan) => sum + plan.span, 0);
                                    totalGoalSpan += objectiveSpan;

                                    return {
                                        ...objective,
                                        span: objectiveSpan,
                                        popoverId: makeSafeId('obj-' + (driver.id || 'd') + '-' + (objective.id || objective.name || colorCounter)),
                                        plans: processedPlans
                                    };
                                });

                                allGoals.push({
                                    ...goal,
                                    span: Math.max(totalGoalSpan, 1),
                                    objectives: processedObjectives,
                                    color: colorInfo.main,
                                    colorAlt: colorInfo.alt
                                });
                            });
                        });
                        return allGoals;
                    }

                    function packTimelineItems(items, years) {
                        if (!items || items.length === 0) return [];
                        const sortedItems = [...items].sort((a, b) => {
                            if (a.startYear !== b.startYear) return a.startYear - b.startYear;
                            return (b.endYear - b.startYear) - (a.endYear - a.startYear);
                        });
                        const lanes = [];
                        sortedItems.forEach(item => {
                            let placed = false;
                            const itemStart = years.findIndex(y => y.value === item.startYear);
                            for (let i = 0; i < lanes.length; i++) {
                                const lastItemInLane = lanes[i][lanes[i].length - 1];
                                const lastEnd = years.findIndex(y => y.value === lastItemInLane.endYear);
                                if (itemStart > lastEnd) { lanes[i].push(item); placed = true; break; }
                            }
                            if (!placed) lanes.push([item]);
                        });
                        return lanes;
                    }


                    function addStaggeredAnimations() {
                        const elements = document.querySelectorAll('.objective-cell, .capability-cell, .action-cell, .timeline-bar, .enabling-item, .dependency-item, .metric-item');
                        elements.forEach((el, index) => {
                            const isTimelineBar = el.classList.contains('timeline-bar');
                            el.style.opacity = '0';
                            el.style.transform = isTimelineBar ? 'scaleX(0)' : 'translateY(20px)';
                            if (isTimelineBar) el.style.transformOrigin = 'left';
                            
                            el.style.transition = 'opacity 0.5s ease-out, transform 0.5s ease-out';
                            setTimeout(() => {
                                el.style.opacity = '1';
                                el.style.transform = isTimelineBar ? 'scaleX(1)' : 'translateY(0)';
                            }, index * 25);
                        });
                    }
                ]]></xsl:text>
                </script>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="stratPlans" match="node()" mode="stratPlans">
        {
            "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",    
            <xsl:variable name="combinedMap" as="map(*)" select="map{
                'short_name': string(translate(translate(current()/own_slot_value[slot_reference = 'short_name']/value,'}',')'),'{',')'))
            }"/>
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
            <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
             "supports_strategic_plan":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'supports_strategic_plan']/value">"<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
             "depends_on_strategic_plans":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'depends_on_strategic_plans']/value">"<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
             "strategic_plan_supports_objective":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value">"<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]
            
        }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>

    <xsl:template name="busObjectives" match="node()" mode="busObjectives">
        <xsl:variable name="obj2svc" select="key('objectivesToQuality', current()/own_slot_value[slot_reference = 'bo_performance_measures']/value)"/>
       
        {
            "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",    
            "className":"<xsl:value-of select="current()/type"/>",
            <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
            }"/>
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
            <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
            "bo_performance_measures":[<xsl:for-each select="$obj2svc">
                 <xsl:variable name="svcQualities" select="key('busServQuality', current()/own_slot_value[slot_reference = 'obj_to_svc_quality_service_quality']/value)"/>
                 <xsl:variable name="sqDesc">
                     <xsl:choose>
                         <xsl:when test="$svcQualities/own_slot_value[slot_reference = 'description']/value"><xsl:value-of select="$svcQualities/own_slot_value[slot_reference = 'description']/value"/></xsl:when>
                         <xsl:otherwise>No description provided</xsl:otherwise>
                     </xsl:choose>
                 </xsl:variable>
                    {
                        "id": "<xsl:value-of select="current()/name"/>",
                        <xsl:variable name="combinedMap" as="map(*)" select="map{
                            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
                            'description': string(translate(translate($sqDesc,'}',')'),'{',')')),
                            'quality': string(translate(translate($svcQualities/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
                        }"/>
                        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
                         <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />
                    }<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]
        }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>

    <xsl:template name="busModels" match="node()" mode="busModels">
        {
            "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",	
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
                'short_name': string(translate(translate(current()/own_slot_value[slot_reference = 'short_name']/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
            "objectives":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'bm_business_goals_objectives']/value">"<xsl:value-of select="."/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]
        }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>
</xsl:stylesheet>
