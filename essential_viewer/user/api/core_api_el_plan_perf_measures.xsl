<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:param name="param1"/>

    <!-- Strategic Plans -->
    <xsl:variable name="allPlans" select="/node()/simple_instance[type='Enterprise_Strategic_Plan']"/>

    <!-- Performance Measures linked to plans -->
    <xsl:variable name="allPerfMeasures" select="/node()/simple_instance[supertype='Performance_Measure'][name=$allPlans/own_slot_value[slot_reference='performance_measures']/value]"/>

    <!-- Performance Measure Categories -->
    <xsl:variable name="allPerfCategories" select="/node()/simple_instance[type='Performance_Measure_Category'][name=$allPerfMeasures/own_slot_value[slot_reference='pm_category']/value]"/>

    <!-- Service Quality Values (the actual priority values) -->
    <xsl:variable name="allSQValues" select="/node()/simple_instance[supertype='Service_Quality_Value'][name=$allPerfMeasures/own_slot_value[slot_reference='pm_performance_value']/value]"/>

    <xsl:template match="knowledge_base">
        {
            "planPerfMeasures": [<xsl:apply-templates select="$allPlans" mode="renderPlan"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>
            ]
        }
    </xsl:template>

    <xsl:template match="node()" mode="renderPlan">
        <xsl:variable name="thisPerfMeasures" select="$allPerfMeasures[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/>
        {
            "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
            "name": "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='name']/value)"/>",
            "measures": [<xsl:for-each select="$thisPerfMeasures">
                <xsl:variable name="thisCategory" select="$allPerfCategories[name=current()/own_slot_value[slot_reference='pm_category']/value]"/>
                <xsl:variable name="thisSQValue" select="$allSQValues[name=current()/own_slot_value[slot_reference='pm_performance_value']/value]"/>
                {
                    "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
                    "category": "<xsl:value-of select="eas:getSafeJSString($thisCategory/own_slot_value[slot_reference='name']/value)"/>",
                    "value": "<xsl:value-of select="eas:getSafeJSString($thisSQValue/own_slot_value[slot_reference='name']/value)"/>",
                    "score": "<xsl:value-of select="$thisSQValue/own_slot_value[slot_reference='service_quality_value_score']/value"/>"
                }<xsl:if test="not(position()=last())">,</xsl:if>
            </xsl:for-each>]
        }<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template>
</xsl:stylesheet>
