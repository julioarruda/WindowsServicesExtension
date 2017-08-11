"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const tl = require('vsts-task-lib/task');
/**
 * Finds the tool path for msbuild/xbuild based on specified msbuild version on Mac or Linux agent
 * @param version
 */
function getMSBuildPath(version) {
    return __awaiter(this, void 0, void 0, function* () {
        let toolPath;
        if (version === '15.0' || version === 'latest') {
            let msbuildPath = tl.which('msbuild', false);
            if (msbuildPath) {
                // msbuild found on the agent, check version
                let msbuildVersion;
                let msbuildVersionCheckTool = tl.tool(msbuildPath);
                msbuildVersionCheckTool.arg(['/version', '/nologo']);
                msbuildVersionCheckTool.on('stdout', function (data) {
                    if (data) {
                        let intData = parseInt(data.toString().trim());
                        if (intData && !isNaN(intData)) {
                            msbuildVersion = intData;
                        }
                    }
                });
                yield msbuildVersionCheckTool.exec();
                if (msbuildVersion) {
                    // found msbuild version on the agent, check if it matches requirements
                    if (msbuildVersion >= 15) {
                        toolPath = msbuildPath;
                    }
                }
            }
        }
        if (!toolPath) {
            // either user selected old version of msbuild or we didn't find matching msbuild version on the agent
            // fallback to xbuild
            toolPath = tl.which('xbuild', false);
            if (!toolPath) {
                // failed to find a version of msbuild / xbuild on the agent
                throw tl.loc('MSB_BuildToolNotFound');
            }
        }
        return toolPath;
    });
}
exports.getMSBuildPath = getMSBuildPath;
