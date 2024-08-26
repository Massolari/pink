import { createElement, Fragment, useEffect as reactEffect } from "react"

export { useState, } from "react"

export const useEffect = (effect, deps) =>
  reactEffect(effect, deps.toArray())


export const component = (element) => createElement(element)

export const fragment = (props, children) => {
  const parsedChildren = typeof children === "object" ? children.toArray() : [children]
  return createElement(Fragment, props, ...parsedChildren)
}

export const getState = ([state, _]) => state

export const setState = ([_, setState], value) => setState(value)
