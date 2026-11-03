export const id = 773;
export const ids = [773];
export const modules = {

/***/ 75773:
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   NodeFS: () => (/* binding */ m)
/* harmony export */ });
/* harmony import */ var _chunk_WGR4JCLS_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(7830);
/* harmony import */ var _chunk_BTBUZ646_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(95349);
/* harmony import */ var fs__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(79896);
/* harmony import */ var path__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(16928);
(0,_chunk_BTBUZ646_js__WEBPACK_IMPORTED_MODULE_1__.j)();var m=class extends _chunk_WGR4JCLS_js__WEBPACK_IMPORTED_MODULE_0__.e{constructor(t){super(t),this.rootDir=path__WEBPACK_IMPORTED_MODULE_3__.resolve(t),fs__WEBPACK_IMPORTED_MODULE_2__.existsSync(path__WEBPACK_IMPORTED_MODULE_3__.join(this.rootDir))||fs__WEBPACK_IMPORTED_MODULE_2__.mkdirSync(this.rootDir)}async init(t,e){return this.pg=t,{emscriptenOpts:{...e,preRun:[...e.preRun||[],r=>{let c=r.FS.filesystems.NODEFS;r.FS.mkdir(_chunk_WGR4JCLS_js__WEBPACK_IMPORTED_MODULE_0__.d),r.FS.mount(c,{root:this.rootDir},_chunk_WGR4JCLS_js__WEBPACK_IMPORTED_MODULE_0__.d)}]}}}async closeFs(){this.pg.Module.FS.quit()}};
//# sourceMappingURL=nodefs.js.map

/***/ })

};
