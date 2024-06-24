import React from "react";
import Spinner from "ink-spinner";

export const spinner = ({ type_ }) => React.createElement(Spinner, { type: type_ }, null);
