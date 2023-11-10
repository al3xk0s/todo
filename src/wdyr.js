/// <reference types="@welldone-software/why-did-you-render" />

import React from "react";
import whyDidYouRender from "@welldone-software/why-did-you-render";

const isDevMode = true;

if (isDevMode) {
    whyDidYouRender(React, {
        trackAllPureComponents: true,
    });
}