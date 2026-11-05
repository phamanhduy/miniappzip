export const id = 519;
export const ids = [519];
export const modules = {

/***/ 67519:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   getAnythingLlmConfig: () => (/* binding */ getAnythingLlmConfig),
/* harmony export */   pendingAiReplies: () => (/* binding */ pendingAiReplies),
/* harmony export */   processAnythingLlmAutoReply: () => (/* binding */ processAnythingLlmAutoReply),
/* harmony export */   saveAnythingLlmConfig: () => (/* binding */ saveAnythingLlmConfig),
/* harmony export */   verifyAndLoadWorkspaces: () => (/* binding */ verifyAndLoadWorkspaces)
/* harmony export */ });
/* harmony import */ var _shared_database_db_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(61993);
/* harmony import */ var _shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(7930);
/* harmony import */ var drizzle_orm__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(63471);
/* harmony import */ var drizzle_orm__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(40033);
/* harmony import */ var _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(70368);
/* harmony import */ var _zalo_zalo_pool_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(79969);
/* harmony import */ var _zalo_zalo_message_helpers_js__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(33750);
/* harmony import */ var _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(30411);







const pendingAiReplies = new Set();
async function getAnythingLlmConfig(orgId) {
    const enabled = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_enabled', false, 'boolean');
    const apiEndpoint = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_api_endpoint', '');
    const apiKey = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_api_key', '');
    const globalWorkspace = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_global_workspace', '');
    const globalMode = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_global_mode', 'query');
    const maxPerUserDay = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_max_per_user_day', 0, 'number');
    const maxTotalDay = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_max_total_day', 0, 'number');
    const tagUser = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_tag_user', false, 'boolean');
    const replyWithoutTag = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_reply_without_tag', true, 'boolean');
    const zaloConfigsStr = await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.getSetting(orgId, 'anythingllm_zalo_configs', '{}');
    let zaloConfigs = {};
    try {
        zaloConfigs = JSON.parse(zaloConfigsStr);
    }
    catch {
        zaloConfigs = {};
    }
    return {
        enabled,
        apiEndpoint,
        apiKey,
        globalWorkspace,
        globalMode,
        maxPerUserDay,
        maxTotalDay,
        tagUser,
        replyWithoutTag,
        zaloConfigs
    };
}
async function saveAnythingLlmConfig(orgId, input) {
    if (input.enabled !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_enabled', input.enabled);
    if (input.apiEndpoint !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_api_endpoint', input.apiEndpoint.trim());
    if (input.apiKey !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_api_key', input.apiKey.trim());
    if (input.globalWorkspace !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_global_workspace', input.globalWorkspace.trim());
    if (input.globalMode !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_global_mode', input.globalMode);
    if (input.maxPerUserDay !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_max_per_user_day', input.maxPerUserDay);
    if (input.maxTotalDay !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_max_total_day', input.maxTotalDay);
    if (input.tagUser !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_tag_user', input.tagUser);
    if (input.replyWithoutTag !== undefined)
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_reply_without_tag', input.replyWithoutTag);
    if (input.zaloConfigs !== undefined) {
        await _system_system_service_js__WEBPACK_IMPORTED_MODULE_2__/* .systemService */ .J.saveSetting(orgId, 'anythingllm_zalo_configs', JSON.stringify(input.zaloConfigs));
    }
    return { success: true };
}
async function verifyAndLoadWorkspaces(endpoint, apiKey) {
    const formattedUrl = endpoint.endsWith('/') ? endpoint.slice(0, -1) : endpoint;
    const response = await fetch(`${formattedUrl}/api/v1/workspaces`, {
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${apiKey}`,
            'Content-Type': 'application/json'
        }
    });
    if (!response.ok) {
        throw new Error(`AnythingLLM API returned status ${response.status}`);
    }
    const data = await response.json();
    const workspaces = data.workspaces || (Array.isArray(data) ? data : []);
    return workspaces.map((w) => ({
        name: w.name,
        slug: w.slug
    }));
}
async function processAnythingLlmAutoReply(orgId, conversationId, incomingMsgId) {
    try {
        const config = await getAnythingLlmConfig(orgId);
        if (!config.enabled || !config.apiEndpoint || !config.apiKey) {
            return;
        }
        const conversation = await _shared_database_db_js__WEBPACK_IMPORTED_MODULE_0__.db.query.conversations.findFirst({
            where: (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .and */ .Uo)((0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__.eq)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.conversations.id, conversationId), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__.eq)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.conversations.orgId, orgId)),
        });
        if (!conversation || !conversation.zaloAccountId)
            return;
        const zaloAccId = conversation.zaloAccountId;
        const zaloConfig = config.zaloConfigs[zaloAccId];
        if (!zaloConfig || !zaloConfig.enabled) {
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] AI auto-reply is disabled for Zalo account ${zaloAccId}`);
            return;
        }
        let activeWorkspace = zaloConfig.workspaceSlug || config.globalWorkspace;
        let activeMode = zaloConfig.aiMode || config.globalMode;
        const limitPerUser = zaloConfig.maxPerUserDay !== undefined && zaloConfig.maxPerUserDay !== null ? zaloConfig.maxPerUserDay : config.maxPerUserDay;
        const limitTotal = zaloConfig.maxTotalDay !== undefined && zaloConfig.maxTotalDay !== null ? zaloConfig.maxTotalDay : config.maxTotalDay;
        const shouldTag = zaloConfig.tagUser !== undefined ? zaloConfig.tagUser : config.tagUser;
        const replyWithoutTag = zaloConfig.replyWithoutTag !== undefined ? zaloConfig.replyWithoutTag : config.replyWithoutTag;
        if (conversation.threadType === 'group' && zaloConfig.groupConfigs) {
            const gConfigs = zaloConfig.groupConfigs;
            const matchedGConfig = gConfigs.find(gc => gc.groupId === conversationId || gc.groupId === conversation.externalThreadId);
            if (matchedGConfig) {
                if (matchedGConfig.workspaceSlug) {
                    activeWorkspace = matchedGConfig.workspaceSlug;
                }
                if (matchedGConfig.aiMode) {
                    activeMode = matchedGConfig.aiMode;
                }
                _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Found Zalo Group specific configuration mapping for group ${conversationId} -> Workspace: ${activeWorkspace}, Mode: ${activeMode}`);
            }
        }
        if (!activeWorkspace) {
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.warn(`[anythingllm-reply] No workspace configured for Zalo account ${zaloAccId} or global default.`);
            return;
        }
        const startOfDay = new Date();
        startOfDay.setHours(0, 0, 0, 0);
        if (limitTotal > 0) {
            const totalSentRes = await _shared_database_db_js__WEBPACK_IMPORTED_MODULE_0__.db.select({ value: (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_7__/* .sql */ .ll) `count(*)` })
                .from(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages)
                .where((0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .and */ .Uo)((0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__.eq)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.senderType, 'self'), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .gte */ .RO)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.sentAt, startOfDay), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .like */ .mj)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.rawZaloMsg, '%"is_ai":true%'), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_7__/* .sql */ .ll) `${_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.conversationId} IN (SELECT id FROM conversations WHERE zalo_account_id = ${zaloAccId})`));
            const totalSent = Number(totalSentRes[0]?.value || 0);
            if (totalSent >= limitTotal) {
                _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Daily total limit reached for Zalo account ${zaloAccId} (${totalSent}/${limitTotal})`);
                return;
            }
        }
        if (limitPerUser > 0) {
            const userSentRes = await _shared_database_db_js__WEBPACK_IMPORTED_MODULE_0__.db.select({ value: (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_7__/* .sql */ .ll) `count(*)` })
                .from(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages)
                .where((0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .and */ .Uo)((0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__.eq)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.conversationId, conversationId), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__.eq)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.senderType, 'self'), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .gte */ .RO)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.sentAt, startOfDay), (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__/* .like */ .mj)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.rawZaloMsg, '%"is_ai":true%')));
            const userSent = Number(userSentRes[0]?.value || 0);
            if (userSent >= limitPerUser) {
                _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Daily limit per conversation reached for ${conversationId} (${userSent}/${limitPerUser})`);
                return;
            }
        }
        const incomingMsg = await _shared_database_db_js__WEBPACK_IMPORTED_MODULE_0__.db.query.messages.findFirst({
            where: (0,drizzle_orm__WEBPACK_IMPORTED_MODULE_6__.eq)(_shared_database_schema_js__WEBPACK_IMPORTED_MODULE_1__.messages.id, incomingMsgId)
        });
        if (!incomingMsg || !incomingMsg.content || incomingMsg.contentType !== 'text') {
            return;
        }
        const sessionId = conversation.threadType === 'group'
            ? `zalo_group_${conversationId}`
            : `zalo_conv_${conversationId}`;
        const instance = _zalo_zalo_pool_js__WEBPACK_IMPORTED_MODULE_3__.zaloPool.getInstance(zaloAccId);
        if (!instance?.api) {
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.warn(`[anythingllm-reply] Zalo account instance ${zaloAccId} not connected or missing api client.`);
            return;
        }
        if (conversation.threadType === 'group' && !replyWithoutTag) {
            const botName = instance.displayName || 'Bot';
            const isMentioned = incomingMsg.content.includes(`@${botName}`) ||
                incomingMsg.content.includes(`@${botName.toLowerCase()}`) ||
                (incomingMsg.rawZaloMsg && incomingMsg.rawZaloMsg.includes(instance.zaloUid || ''));
            if (!isMentioned) {
                return;
            }
        }
        _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Sending prompt to AnythingLLM workspace "${activeWorkspace}" (mode: ${activeMode})...`);
        const formattedUrl = config.apiEndpoint.endsWith('/') ? config.apiEndpoint.slice(0, -1) : config.apiEndpoint;
        const chatUrl = `${formattedUrl}/api/v1/workspace/${activeWorkspace}/chat`;
        const chatResponse = await fetch(chatUrl, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${config.apiKey}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                message: incomingMsg.content,
                mode: activeMode,
                sessionId: sessionId
            })
        });
        if (!chatResponse.ok) {
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.error(`[anythingllm-reply] AnythingLLM API returned error status: ${chatResponse.status}`);
            return;
        }
        const chatResult = await chatResponse.json();
        let replyText = chatResult.textResponse || chatResult.response || '';
        if (!replyText) {
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Received empty response from AnythingLLM.`);
            return;
        }
        replyText = replyText.replace(/<think>[\s\S]*?<\/think>/gi, '').trim();
        replyText = replyText.replace(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g, '$1 ($2)');
        replyText = replyText.replace(/^#+\s+/gm, '');
        replyText = replyText.replace(/\*\*([^*]+)\*\*/g, '$1');
        replyText = replyText.replace(/\*([^*]+)\*/g, '$1');
        replyText = replyText.replace(/`([^`]+)`/g, '$1');
        replyText = replyText.trim();
        if (shouldTag && conversation.threadType === 'group' && incomingMsg.senderName) {
            replyText = `@${incomingMsg.senderName} ${replyText}`;
        }
        pendingAiReplies.add(replyText);
        _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Sending AI response to Zalo thread ${conversation.externalThreadId}`);
        const threadTypeNum = conversation.threadType === 'group' ? 1 : 0;
        const threadId = conversation.externalThreadId || '';
        let quoteData = undefined;
        if (incomingMsg.zaloMsgId && incomingMsg.rawZaloMsg) {
            try {
                const raw = typeof incomingMsg.rawZaloMsg === 'string'
                    ? JSON.parse(incomingMsg.rawZaloMsg)
                    : incomingMsg.rawZaloMsg;
                const data = raw.data || raw;
                const summary = incomingMsg.content || '';
                let tsVal = Number(data.ts);
                if (isNaN(tsVal) || tsVal <= 0) {
                    tsVal = Date.now();
                }
                quoteData = {
                    ...data,
                    msgId: String(data.msgId || data.globalMsgId || incomingMsg.zaloMsgId),
                    globalMsgId: String(data.globalMsgId || data.msgId || incomingMsg.zaloMsgId),
                    cliMsgId: String(data.cliMsgId || data.ts || Date.now()),
                    uidFrom: String(data.uidFrom || data.ownerId || incomingMsg.senderUid),
                    ownerId: String(data.ownerId || data.uidFrom || incomingMsg.senderUid),
                    fromD: data.fromD || data.senderName || incomingMsg.senderName || 'Người dùng',
                    content: summary,
                    msg: summary,
                    ts: tsVal,
                    cliMsgType: data.cliMsgType || 1,
                    msgType: data.msgType || 'webchat',
                };
            }
            catch (e) {
                _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.error('[anythingllm-reply] Failed to parse rawZaloMsg for quoteData:', e);
            }
        }
        if (!quoteData && incomingMsg.zaloMsgId) {
            quoteData = {
                msgId: String(incomingMsg.zaloMsgId),
                globalMsgId: String(incomingMsg.zaloMsgId),
                cliMsgId: String(Date.now()),
                uidFrom: String(incomingMsg.senderUid),
                ownerId: String(incomingMsg.senderUid),
                fromD: incomingMsg.senderName || 'Người dùng',
                content: incomingMsg.content || '',
                msg: incomingMsg.content || '',
                ts: Date.now(),
                cliMsgType: 1,
                msgType: 'webchat',
            };
        }
        _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] Debug sending: threadId=${threadId}, threadTypeNum=${threadTypeNum}, typeof replyText=${typeof replyText}, replyTextLen=${replyText?.length}`);
        const sendSplitMessage = async (apiClient, targetId, text, typeNum, quote) => {
            const maxLength = 1900;
            if (text.length <= maxLength) {
                await (0,_zalo_zalo_message_helpers_js__WEBPACK_IMPORTED_MODULE_4__/* .sendMessageToZalo */ .R5)(apiClient, targetId, { text }, typeNum, undefined, undefined, quote);
                return;
            }
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.info(`[anythingllm-reply] AI reply is long (${text.length} chars). Splitting into chunks...`);
            const chunks = [];
            let currentText = text;
            while (currentText.length > 0) {
                if (currentText.length <= maxLength) {
                    chunks.push(currentText);
                    break;
                }
                let splitIdx = currentText.lastIndexOf('\n', maxLength);
                if (splitIdx === -1 || splitIdx < maxLength / 2) {
                    splitIdx = currentText.lastIndexOf(' ', maxLength);
                }
                if (splitIdx === -1 || splitIdx < maxLength / 2) {
                    splitIdx = maxLength;
                }
                chunks.push(currentText.slice(0, splitIdx));
                currentText = currentText.slice(splitIdx).trim();
            }
            for (let i = 0; i < chunks.length; i++) {
                const currentQuote = i === 0 ? quote : undefined;
                await (0,_zalo_zalo_message_helpers_js__WEBPACK_IMPORTED_MODULE_4__/* .sendMessageToZalo */ .R5)(apiClient, targetId, { text: chunks[i] }, typeNum, undefined, undefined, currentQuote);
                if (i < chunks.length - 1) {
                    await new Promise(r => setTimeout(r, 800));
                }
            }
        };
        try {
            await sendSplitMessage(instance.api, threadId, replyText, threadTypeNum, quoteData);
        }
        catch (sendErr) {
            _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.warn(`[anythingllm-reply] Quote reply failed: ${sendErr.message || sendErr}. Retrying as normal message without quote...`);
            try {
                await sendSplitMessage(instance.api, threadId, replyText, threadTypeNum, undefined);
            }
            catch (retryErr) {
                _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.error(`[anythingllm-reply] Retry also failed: ${retryErr.message || retryErr}. Stack: ${retryErr.stack}`);
                if (retryErr.response?.data) {
                    _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.error(`[anythingllm-reply] Zalo API error response:`, JSON.stringify(retryErr.response.data));
                }
                throw retryErr;
            }
        }
    }
    catch (err) {
        _shared_utils_logger_js__WEBPACK_IMPORTED_MODULE_5__/* .logger */ .v.error('[anythingllm-reply] Auto-reply processing error:', err.message || err);
    }
}


/***/ })

};
